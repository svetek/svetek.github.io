<#
.SYNOPSIS
    Point-in-time access audit for a client Entra ID tenant (MSP onboarding / assessment).

.DESCRIPTION
    Exports the day-0 access baseline to CSV files plus a summary report:
      1. Directory role assignments (active + PIM eligible)
      2. Guest accounts with last sign-in activity
      3. Enterprise app assignments (users/groups assigned to service principals)
      4. Delegated OAuth consent grants (admin and user consent)
      5. App registrations with credential expiry (client secrets / certificates)
      6. Conditional Access policies and resolved exclusion groups/users
      7. Role-assignable groups and their members

    Read-only. Makes no changes to the tenant.

.NOTES
    Requires: Microsoft.Graph PowerShell SDK (Install-Module Microsoft.Graph -Scope CurrentUser)
    Sign in with an account that has at least Global Reader in the client tenant.
    signInActivity requires Entra ID P1 or higher in the target tenant. The script
    falls back gracefully if unavailable.

    Partner relationships (DAP/GDAP left by a previous MSP) are not exposed via
    customer-side Graph. Check manually: M365 admin center > Settings > Partner relationships.
    Mailbox forwarding/delegation requires ExchangeOnlineManagement and is out of
    scope for this script. See the onboarding audit procedure doc.

.EXAMPLE
    .\Invoke-TenantAccessAudit.ps1 -ClientName "Contoso" -TenantId "contoso.onmicrosoft.com"
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory)] [string]$ClientName,
    [Parameter(Mandatory)] [string]$TenantId,
    [string]$OutputRoot = ".\AuditReports"
)

$ErrorActionPreference = 'Stop'
$stamp   = Get-Date -Format 'yyyyMMdd-HHmm'
$outDir  = Join-Path $OutputRoot "$ClientName-$stamp"
New-Item -ItemType Directory -Path $outDir -Force | Out-Null

$requiredScopes = @(
    'Directory.Read.All',
    'RoleManagement.Read.Directory',
    'AuditLog.Read.All',
    'Policy.Read.All',
    'Application.Read.All'
)

Write-Host "Connecting to tenant $TenantId ..." -ForegroundColor Cyan
Connect-MgGraph -TenantId $TenantId -Scopes $requiredScopes -NoWelcome

$org = Get-MgOrganization
Write-Host "Connected to: $($org.DisplayName)" -ForegroundColor Green

$summary = [ordered]@{}

# ---------------------------------------------------------------
# 1. Directory role assignments (active)
# ---------------------------------------------------------------
Write-Host "[1/7] Directory role assignments (active)..." -ForegroundColor Cyan
$roleDefs = Get-MgRoleManagementDirectoryRoleDefinition -All
$roleDefMap = @{}
foreach ($rd in $roleDefs) { $roleDefMap[$rd.Id] = $rd.DisplayName }

$activeAssignments = Get-MgRoleManagementDirectoryRoleAssignment -All -ExpandProperty Principal
$activeOut = foreach ($a in $activeAssignments) {
    $p = $a.Principal.AdditionalProperties
    [pscustomobject]@{
        RoleName        = $roleDefMap[$a.RoleDefinitionId]
        AssignmentType  = 'Active'
        PrincipalType   = ($p.'@odata.type' -replace '#microsoft.graph.','')
        DisplayName     = $p.displayName
        UPNOrAppId      = if ($p.userPrincipalName) { $p.userPrincipalName } else { $p.appId }
        UserType        = $p.userType
        DirectoryScope  = $a.DirectoryScopeId
    }
}
$activeOut | Export-Csv (Join-Path $outDir '1-RoleAssignments-Active.csv') -NoTypeInformation
$summary['Active role assignments'] = $activeOut.Count
$summary['Global Administrators (active)'] = ($activeOut | Where-Object RoleName -eq 'Global Administrator').Count
$summary['Guests holding admin roles'] = ($activeOut | Where-Object UserType -eq 'Guest').Count

# PIM eligible assignments (skips cleanly if tenant has no PIM / P2)
Write-Host "[1/7] Directory role assignments (PIM eligible)..." -ForegroundColor Cyan
try {
    $eligible = Get-MgRoleManagementDirectoryRoleEligibilitySchedule -All -ExpandProperty Principal
    $eligibleOut = foreach ($e in $eligible) {
        $p = $e.Principal.AdditionalProperties
        [pscustomobject]@{
            RoleName       = $roleDefMap[$e.RoleDefinitionId]
            AssignmentType = 'Eligible'
            PrincipalType  = ($p.'@odata.type' -replace '#microsoft.graph.','')
            DisplayName    = $p.displayName
            UPNOrAppId     = if ($p.userPrincipalName) { $p.userPrincipalName } else { $p.appId }
            UserType       = $p.userType
            DirectoryScope = $e.DirectoryScopeId
        }
    }
    $eligibleOut | Export-Csv (Join-Path $outDir '1-RoleAssignments-Eligible.csv') -NoTypeInformation
    $summary['PIM eligible assignments'] = $eligibleOut.Count
}
catch {
    Write-Warning "PIM eligibility query failed (likely no P2/PIM in tenant): $($_.Exception.Message)"
    $summary['PIM eligible assignments'] = 'N/A (no PIM or insufficient license)'
}

# ---------------------------------------------------------------
# 2. Guest accounts with last sign-in
# ---------------------------------------------------------------
Write-Host "[2/7] Guest accounts..." -ForegroundColor Cyan
$signInAvailable = $true
try {
    $guests = Get-MgUser -All -Filter "userType eq 'Guest'" `
        -Property Id,DisplayName,UserPrincipalName,Mail,CreatedDateTime,AccountEnabled,ExternalUserState,SignInActivity
}
catch {
    Write-Warning "signInActivity unavailable (needs Entra ID P1). Exporting guests without sign-in data."
    $signInAvailable = $false
    $guests = Get-MgUser -All -Filter "userType eq 'Guest'" `
        -Property Id,DisplayName,UserPrincipalName,Mail,CreatedDateTime,AccountEnabled,ExternalUserState
}

$guestOut = foreach ($g in $guests) {
    [pscustomobject]@{
        DisplayName        = $g.DisplayName
        Mail               = $g.Mail
        UPN                = $g.UserPrincipalName
        Created            = $g.CreatedDateTime
        AccountEnabled     = $g.AccountEnabled
        InvitationState    = $g.ExternalUserState
        LastSignIn         = if ($signInAvailable) { $g.SignInActivity.LastSignInDateTime } else { 'unavailable' }
        LastNonInteractive = if ($signInAvailable) { $g.SignInActivity.LastNonInteractiveSignInDateTime } else { 'unavailable' }
    }
}
$guestOut | Export-Csv (Join-Path $outDir '2-Guests.csv') -NoTypeInformation
$summary['Guest accounts'] = $guestOut.Count
if ($signInAvailable) {
    $cutoff = (Get-Date).AddDays(-90)
    $stale = $guestOut | Where-Object {
        (-not $_.LastSignIn) -or ([datetime]$_.LastSignIn -lt $cutoff)
    }
    $summary['Guests stale 90+ days or never signed in'] = $stale.Count
}

# ---------------------------------------------------------------
# 3. Enterprise app assignments
# ---------------------------------------------------------------
Write-Host "[3/7] Enterprise app assignments..." -ForegroundColor Cyan
$sps = Get-MgServicePrincipal -All -Property Id,DisplayName,AppId,AccountEnabled,ServicePrincipalType,AppOwnerOrganizationId
$appAssignOut = New-Object System.Collections.Generic.List[object]
foreach ($sp in ($sps | Where-Object ServicePrincipalType -eq 'Application')) {
    $assignments = Get-MgServicePrincipalAppRoleAssignedTo -ServicePrincipalId $sp.Id -All -ErrorAction SilentlyContinue
    foreach ($as in $assignments) {
        $appAssignOut.Add([pscustomobject]@{
            AppDisplayName = $sp.DisplayName
            AppId          = $sp.AppId
            PrincipalType  = $as.PrincipalType
            PrincipalName  = $as.PrincipalDisplayName
            AssignedOn     = $as.CreatedDateTime
        })
    }
}
$appAssignOut | Export-Csv (Join-Path $outDir '3-EnterpriseAppAssignments.csv') -NoTypeInformation
$summary['Enterprise app assignments'] = $appAssignOut.Count

# ---------------------------------------------------------------
# 4. Delegated OAuth consent grants
# ---------------------------------------------------------------
Write-Host "[4/7] OAuth consent grants..." -ForegroundColor Cyan
$spMap = @{}
foreach ($sp in $sps) { $spMap[$sp.Id] = $sp.DisplayName }
$grants = Get-MgOauth2PermissionGrant -All
$grantOut = foreach ($gr in $grants) {
    [pscustomobject]@{
        ClientApp   = $spMap[$gr.ClientId]
        ConsentType = $gr.ConsentType
        Scopes      = $gr.Scope
        ResourceApp = $spMap[$gr.ResourceId]
    }
}
$grantOut | Export-Csv (Join-Path $outDir '4-OAuthConsentGrants.csv') -NoTypeInformation
$summary['Delegated consent grants'] = $grantOut.Count
$highRiskScopes = 'Mail\.ReadWrite|Mail\.Send|Directory\.ReadWrite|RoleManagement|Files\.ReadWrite\.All|full_access_as_app|EWS\.AccessAsUser'
$summary['Grants with high-privilege scopes'] = ($grantOut | Where-Object Scopes -match $highRiskScopes).Count

# ---------------------------------------------------------------
# 5. App registrations with credentials
# ---------------------------------------------------------------
Write-Host "[5/7] App registrations and credentials..." -ForegroundColor Cyan
$apps = Get-MgApplication -All -Property Id,DisplayName,AppId,CreatedDateTime,PasswordCredentials,KeyCredentials
$appCredOut = New-Object System.Collections.Generic.List[object]
foreach ($app in $apps) {
    foreach ($cred in $app.PasswordCredentials) {
        $appCredOut.Add([pscustomobject]@{
            AppName  = $app.DisplayName
            AppId    = $app.AppId
            CredType = 'ClientSecret'
            CredName = $cred.DisplayName
            Expires  = $cred.EndDateTime
        })
    }
    foreach ($cred in $app.KeyCredentials) {
        $appCredOut.Add([pscustomobject]@{
            AppName  = $app.DisplayName
            AppId    = $app.AppId
            CredType = 'Certificate'
            CredName = $cred.DisplayName
            Expires  = $cred.EndDateTime
        })
    }
}
$appCredOut | Export-Csv (Join-Path $outDir '5-AppRegistrationCredentials.csv') -NoTypeInformation
$summary['App registrations'] = $apps.Count
$summary['App credentials (secrets/certs)'] = $appCredOut.Count

# ---------------------------------------------------------------
# 6. Conditional Access policies and exclusions
# ---------------------------------------------------------------
Write-Host "[6/7] Conditional Access policies..." -ForegroundColor Cyan
$caOut = New-Object System.Collections.Generic.List[object]
try {
    $caPolicies = Get-MgIdentityConditionalAccessPolicy -All
    foreach ($pol in $caPolicies) {
        $exGroups = foreach ($gid in $pol.Conditions.Users.ExcludeGroups) {
            try { (Get-MgGroup -GroupId $gid -Property DisplayName).DisplayName } catch { "$gid (deleted?)" }
        }
        $exUsers = foreach ($uid in $pol.Conditions.Users.ExcludeUsers) {
            if ($uid -eq 'GuestsOrExternalUsers') { $uid; continue }
            try { (Get-MgUser -UserId $uid -Property UserPrincipalName).UserPrincipalName } catch { "$uid (deleted?)" }
        }
        $caOut.Add([pscustomobject]@{
            PolicyName     = $pol.DisplayName
            State          = $pol.State
            ExcludedGroups = ($exGroups -join '; ')
            ExcludedUsers  = ($exUsers -join '; ')
        })
    }
    $caOut | Export-Csv (Join-Path $outDir '6-ConditionalAccessPolicies.csv') -NoTypeInformation
    $summary['CA policies'] = $caOut.Count
    $summary['CA policies disabled/report-only'] = ($caOut | Where-Object State -ne 'enabled').Count
}
catch {
    Write-Warning "CA export failed: $($_.Exception.Message)"
    $summary['CA policies'] = 'FAILED - check Policy.Read.All'
}

# ---------------------------------------------------------------
# 7. Role-assignable groups
# ---------------------------------------------------------------
Write-Host "[7/7] Role-assignable groups..." -ForegroundColor Cyan
$raGroups = Get-MgGroup -All -Filter "isAssignableToRole eq true"
$raOut = New-Object System.Collections.Generic.List[object]
foreach ($g in $raGroups) {
    $members = Get-MgGroupMember -GroupId $g.Id -All
    foreach ($m in $members) {
        $raOut.Add([pscustomobject]@{
            GroupName  = $g.DisplayName
            MemberName = $m.AdditionalProperties.displayName
            MemberUPN  = $m.AdditionalProperties.userPrincipalName
        })
    }
}
$raOut | Export-Csv (Join-Path $outDir '7-RoleAssignableGroupMembers.csv') -NoTypeInformation
$summary['Role-assignable groups'] = $raGroups.Count

# ---------------------------------------------------------------
# Summary report
# ---------------------------------------------------------------
$report = @()
$report += "# Access Audit Summary: $($org.DisplayName)"
$report += ""
$report += "Tenant ID: $($org.Id)"
$report += "Audit date: $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
$report += "Run by: $((Get-MgContext).Account)"
$report += ""
$report += "| Item | Count |"
$report += "|---|---|"
foreach ($k in $summary.Keys) { $report += "| $k | $($summary[$k]) |" }
$report += ""
$report += "## Manual checks required (not covered by Graph)"
$report += ""
$report += "- [ ] Partner relationships (DAP/GDAP): M365 admin center > Settings > Partner relationships"
$report += "- [ ] Mailbox forwarding rules and delegations (ExchangeOnlineManagement)"
$report += "- [ ] Transport rules forwarding mail externally"
$report += "- [ ] Break-glass accounts identified and documented"
$report | Set-Content (Join-Path $outDir '0-Summary.md')

Disconnect-MgGraph | Out-Null

Write-Host "`nAudit complete. Output: $outDir" -ForegroundColor Green
$summary.GetEnumerator() | ForEach-Object { Write-Host ("  {0}: {1}" -f $_.Key, $_.Value) }
