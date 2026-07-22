---
title: "Entra ID Tenant Access Audit Procedure"
seo_title: "Entra ID Tenant Access Audit Procedure | MSP Onboarding Guide"
description: "Run a read-only day-0 Microsoft Entra ID tenant access audit for client onboarding, including privileged roles, guests, app consent, Conditional Access exclusions, and manual MSP checks."
keywords: "Entra ID tenant access audit, Microsoft 365 onboarding audit, MSP security assessment, Microsoft Graph PowerShell audit, Entra privileged access review, guest account review, OAuth consent audit, IT support Vancouver WA, IT support Portland OR, IT support Seattle WA"
canonical: https://help.svetek.com/docs/Configuration/Azure/entra-id-tenant-access-audit/
og_title: "Entra ID Tenant Access Audit Procedure"
og_description: "A practical read-only procedure for establishing a day-0 Microsoft Entra ID access baseline during client onboarding."
og_type: article
og_image: https://help.svetek.com/images/logo_horizontal_whitetext.svg
og_url: https://help.svetek.com/docs/Configuration/Azure/entra-id-tenant-access-audit/
published_time: 2026-07-22T00:00:00+00:00
date: 2026-07-22
tags:
  - Microsoft Entra
  - Microsoft 365
  - Tenant Audit
  - MSP Onboarding
twitter_title: "Entra ID Tenant Access Audit"
twitter_description: "Run a read-only tenant access audit before remediation, Conditional Access rollout, or client onboarding."
twitter_image: https://help.svetek.com/images/logo_horizontal_whitetext.svg
twitter_image_alt: "Svetek logo"
layout: docs
---

Use this procedure to establish a documented day-0 access baseline for a client Microsoft Entra ID tenant before making changes. The audit identifies excessive privileges, leftover access from previous IT providers, stale guest accounts, risky application consent, app credentials, Conditional Access exclusions, and role-assignable group membership.

Run it during client onboarding, during a security assessment, or before deploying a [Conditional Access baseline](/docs/Configuration/Azure/deploy-conditional-access-baseline/). The procedure is read-only. It does not remediate anything in the client tenant.

Expected time is **30 to 60 minutes per tenant**, plus review and documentation time.

Source links were checked on **July 22, 2026**. Microsoft Entra, Microsoft Graph, Partner Center, and Microsoft 365 admin center behavior can change, so confirm the linked Microsoft documentation before using the procedure for a production tenant.

## Prerequisites

Before running the audit, confirm:

- You have an account in the client tenant with at least the **Global Reader** role. Global Administrator also works, but is not required for the audit itself.
- You are using PowerShell 7.x.
- The Microsoft Graph PowerShell SDK is installed.
- You have the downloadable audit script from this page.
- You know the client tenant ID or verified `*.onmicrosoft.com` tenant name.
- You have a secure location for the exported audit files.

Install the Microsoft Graph PowerShell SDK from PowerShell:

```powershell
Install-Module Microsoft.Graph -Scope CurrentUser
```

Guest last sign-in data uses the `signInActivity` property and may require the right Entra licensing and permissions in the target tenant. The script falls back gracefully if sign-in activity is unavailable and marks those fields as unavailable.

## Download the Audit Script

Download the companion script:

[Download Invoke-TenantAccessAudit.ps1](scripts/Invoke-TenantAccessAudit.ps1)

The script is published as a page-local companion file instead of being pasted into the article. That keeps the procedure readable while preserving a versionable source file in Git.

For public documentation, publish scripts this way:

- Store script files beside the article in a `scripts/` folder.
- Keep scripts read-only unless the article is explicitly a remediation guide.
- Include a clear synopsis, required modules, scopes, and example usage in the script header.
- Link to the script from the article and show the exact run command.
- Do not publish client-specific exports, screenshots, tenant IDs, domains, app IDs, or access findings.
- Use Git history for change review; add a release tag or checksum only if the script becomes a broadly distributed tool.

Avoid `curl | iex` style instructions for administrative scripts. Make the technician download or review the script before execution.

## Run the Audit Script

1. Open PowerShell 7.
2. Change to the folder containing `Invoke-TenantAccessAudit.ps1`.
3. Run the script:

   ```powershell
   .\Invoke-TenantAccessAudit.ps1 -ClientName "ClientShortName" -TenantId "client.onmicrosoft.com"
   ```

4. Sign in when prompted using the auditing account.
5. Consent to the requested read-only Microsoft Graph scopes if prompted.
6. Wait for the script to create a timestamped folder under `.\AuditReports\`.

The script requests these Microsoft Graph scopes:

- `Directory.Read.All`
- `RoleManagement.Read.Directory`
- `AuditLog.Read.All`
- `Policy.Read.All`
- `Application.Read.All`

## Exported Files

The script writes one summary report plus CSV exports for review.

| File | Contents |
| --- | --- |
| `0-Summary.md` | Counts and manual-check list |
| `1-RoleAssignments-Active.csv` | Active directory role assignments |
| `1-RoleAssignments-Eligible.csv` | PIM eligible role assignments, when available |
| `2-Guests.csv` | Guest accounts with last sign-in information, when available |
| `3-EnterpriseAppAssignments.csv` | Users and groups assigned to enterprise applications |
| `4-OAuthConsentGrants.csv` | Delegated OAuth consent grants and scopes |
| `5-AppRegistrationCredentials.csv` | App registrations with client secret and certificate expiry |
| `6-ConditionalAccessPolicies.csv` | Conditional Access policies with resolved exclusions |
| `7-RoleAssignableGroupMembers.csv` | Members of role-assignable groups |

Treat the output folder as confidential. It enumerates privileged accounts, guests, application permissions, Conditional Access exclusions, and other sensitive security posture details.

## Manual Checks

Some MSP onboarding checks are not covered by the script. Complete them manually and record the result in the onboarding ticket or assessment report.

### Partner Relationships

Check the Microsoft 365 admin center:

1. Open **Settings**.
2. Open **Partner relationships**.
3. Record every listed partner relationship.
4. Flag any previous IT provider still holding DAP or GDAP.

DAP, the older delegated admin model, is an immediate removal candidate during onboarding unless there is a documented reason to keep it temporarily. GDAP should be time-bound, least-privileged, and mapped to known partner access requirements.

### Mailbox Forwarding and Delegation

Connect to Exchange Online and check for external forwarding:

```powershell
Connect-ExchangeOnline
Get-Mailbox -ResultSize Unlimited |
    Where-Object { $_.ForwardingSmtpAddress -or $_.ForwardingAddress } |
    Select-Object DisplayName, ForwardingSmtpAddress, ForwardingAddress, DeliverToMailboxAndForward
```

Review mailbox delegation separately when onboarding scope includes Exchange access cleanup.

### Transport Rules

Check transport rules that redirect or blind-copy mail externally:

```powershell
Get-TransportRule | Where-Object { $_.RedirectMessageTo -or $_.BlindCopyTo }
```

External forwarding rules can represent legitimate workflows, abandoned provider access, or compromise persistence. Do not remove them during the audit; document them for approved remediation.

### Break-Glass Accounts

Identify whether the tenant has documented emergency access accounts. If none exist, record that as a remediation item.

At minimum, the client should know:

- Which accounts are emergency access accounts.
- Where credentials and MFA recovery methods are stored.
- Whether at least one emergency account uses the tenant's internal `*.onmicrosoft.com` domain.
- Which Conditional Access policies exclude those accounts.
- When the accounts were last tested.

## Review the Results

Work through the exports in this order and flag findings.

### Role Assignments

Review `1-RoleAssignments-Active.csv` and `1-RoleAssignments-Eligible.csv`.

Flag:

- More than two active Global Administrators.
- Any guest account holding an admin role.
- Accounts belonging to a previous IT provider.
- Service accounts with standing admin roles.
- Admin roles assigned to shared or generic accounts, such as `office`, `admin`, or `reception`.
- Eligible PIM assignments that no longer match the client's operating model.

Guest administrators and old provider accounts are high-priority findings because they can preserve access after a client changes providers.

### Guest Accounts

Review `2-Guests.csv`.

Flag:

- Guests with no sign-in in 90 or more days.
- Guests that never signed in.
- Pending guest invitations older than 30 days.
- Guests from unrecognized domains.
- Disabled guest accounts that still appear in important groups or app assignments.

Stale guests are removal candidates, but confirm business ownership before cleanup.

### Enterprise Apps and OAuth Consent

Review `3-EnterpriseAppAssignments.csv`, `4-OAuthConsentGrants.csv`, and `5-AppRegistrationCredentials.csv`.

Flag:

- Consent grants with high-privilege scopes such as `Mail.ReadWrite`, `Mail.Send`, `Directory.ReadWrite.All`, `Files.ReadWrite.All`, `full_access_as_app`, or `EWS.AccessAsUser`.
- `ConsentType = AllPrincipals`, which means tenant-wide admin consent.
- App registrations with active client secrets or certificates created by unknown parties.
- Expired or soon-expiring credentials on apps the client still depends on.
- Enterprise apps assigned to old provider groups or unknown users.

Attackers and departed providers can both persist through app consent and app credentials. Treat unknown high-privilege apps as high-priority findings until identified.

### Conditional Access

Review `6-ConditionalAccessPolicies.csv`.

Flag:

- No Conditional Access policies.
- Policies in `disabled` state without a documented reason.
- Policies in `enabledForReportingButNotEnforced` state that were never reviewed.
- Excluded users with no documented justification.
- Exclusion groups with unclear ownership or stale membership.
- Break-glass accounts that are not clearly represented in exclusions.

Every Conditional Access exclusion needs a reason. Unexplained exclusions are findings even when the policy itself is otherwise well designed.

### Role-Assignable Groups

Review `7-RoleAssignableGroupMembers.csv`.

Membership in a role-assignable group can grant admin rights indirectly. Confirm every member is expected, named, and documented. Pay extra attention to nested operational groups, old provider accounts, and synchronized groups that may be managed outside Entra.

## Document and Deliver

After the audit:

1. Store the full export folder in the client's documentation area with access restricted to engineering staff.
2. Summarize findings in the assessment report or onboarding ticket.
3. Record the finding, risk level, recommended action, and client decision for each issue.
4. Do not remediate during the audit.
5. Use a separate approved change for removing old provider access, disabling stale guests, revoking consent, or changing Conditional Access.
6. Keep this baseline as the reference point for recurring access reviews once the tenant reaches steady state.

This separation matters. The audit answers, "What access exists today?" Remediation answers, "What are we approved to change?"

## Roles and Responsibilities

| Step | Owner |
| --- | --- |
| Run audit script and manual checks | Onboarding technician |
| Review findings and assign risk | Engineer or team lead |
| Approve remediation plan | Client point of contact |
| Store evidence | Onboarding technician |
| Schedule recurring review | Account owner or service manager |

## When to Escalate

Escalate before remediation if:

- A previous provider still has DAP or broad GDAP access.
- A guest account holds any privileged role.
- Unknown apps have high-privilege delegated consent.
- Unknown app registrations have valid client secrets or certificates.
- Conditional Access excludes unknown users or broad groups.
- No break-glass account exists.
- No current admin can explain the tenant's privileged access model.

These findings do not always mean compromise. They do mean the tenant needs deliberate review before normal onboarding changes continue.

## References

- [Microsoft Learn: Install the Microsoft Graph PowerShell SDK](https://learn.microsoft.com/en-us/powershell/microsoftgraph/installation)
- [Microsoft Learn: Microsoft Entra built-in roles](https://learn.microsoft.com/en-us/entra/identity/role-based-access-control/permissions-reference)
- [Microsoft Graph: signIn resource type](https://learn.microsoft.com/en-us/graph/api/resources/signin)
- [Microsoft Graph: signInActivity resource type](https://learn.microsoft.com/en-us/graph/api/resources/signinactivity)
- [Microsoft Learn: GDAP introduction](https://learn.microsoft.com/en-us/partner-center/customers/gdap-introduction)
- [Microsoft Learn: Delegated administration in Microsoft Entra ID](https://learn.microsoft.com/en-us/entra/identity/users/directory-delegated-administration-primer)

## Need Help

For Microsoft 365 tenant onboarding in Vancouver WA, Portland OR, Seattle WA, and remote client environments, Svetek can help run the access audit, review privileged roles, document risky app consent, validate partner relationships, and plan remediation safely.

