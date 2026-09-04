---
title: "Configure Microsoft HVE SMTP with Security Defaults and Conditional Access"
seo_title: "Microsoft HVE SMTP, Security Defaults, and Conditional Access | MSP Guide"
description: "Technician guidance for using Microsoft High Volume Email SMTP with a copier or scanner while replacing Security Defaults with Conditional Access and narrowly exempting an HVE basic-auth account."
keywords: "Microsoft HVE SMTP, High Volume Email scanner SMTP, Security Defaults HVE, Conditional Access HVE account, Konica SMTP Microsoft 365, AllowBasicAuthSmtp, Microsoft 365 copier SMTP"
canonical: https://help.svetek.com/docs/Configuration/Microsoft_365/hve-security-defaults-conditional-access/
og_title: "Configure Microsoft HVE SMTP with Security Defaults and Conditional Access"
og_description: "Keep a copier's HVE basic SMTP account working without removing protection from the rest of the Microsoft 365 tenant."
og_type: article
og_image: https://help.svetek.com/images/logo_horizontal_whitetext.svg
og_url: https://help.svetek.com/docs/Configuration/Microsoft_365/hve-security-defaults-conditional-access/
published_time: 2026-08-24T00:00:00+00:00
date: 2026-08-24
tags:
  - Microsoft 365
  - Exchange Online
  - High Volume Email
  - Microsoft Entra
  - Conditional Access
twitter_title: "Microsoft HVE SMTP and Conditional Access"
twitter_description: "Use Conditional Access to protect a tenant while narrowly allowing an HVE basic SMTP account for a copier or scanner."
twitter_image: https://help.svetek.com/images/logo_horizontal_whitetext.svg
twitter_image_alt: "Svetek logo"
layout: docs
---

Use this procedure when a multifunction device, such as a Konica C3351, must send internal email through Microsoft 365 High Volume Email (HVE) with a dedicated HVE username and password. It explains why **Security Defaults** blocks that configuration and how a Business Premium tenant can retain tenant-wide protections with **Conditional Access** instead.

HVE is for automated, transactional, and device-generated messages. It uses a dedicated HVE account rather than a user or shared mailbox. HVE can send to recipients in the organization's accepted domains; it is **not** a general Internet relay service.

## The key limitation

Security Defaults is an all-or-nothing tenant setting. It has no user, group, application, protocol, or location exclusions. You **cannot** whitelist one copier, service account, or HVE account while leaving Security Defaults enabled.

Security Defaults disables basic authentication, including SMTP basic authentication. Therefore, a copier that authenticates to HVE with a username and password cannot use that method while Security Defaults is enabled. The practical choices are:

| Option | When to use it | Security result |
| --- | --- | --- |
| Use HVE with OAuth | The device or application supports OAuth and can be configured and maintained accordingly. | Retain Security Defaults if no other incompatibility exists. |
| Disable Security Defaults | The device requires HVE SMTP basic authentication and the tenant has no Conditional Access licensing. | Required for basic HVE SMTP, but the tenant loses the protections Security Defaults applied. Replace them as soon as licensing permits. |
| Replace Security Defaults with Conditional Access | The device requires HVE SMTP basic authentication and the tenant has Microsoft Entra ID P1, such as Microsoft 365 Business Premium. | Recommended. Conditional Access provides granular policies and permits a narrowly scoped HVE-account exclusion. |

> **Do not disable Security Defaults and stop there.** That removes baseline protections for every user. In a Business Premium tenant, prepare and enable equivalent Conditional Access protections immediately.

## Recommended design for Business Premium

Microsoft 365 Business Premium includes Microsoft Entra ID P1, which supports Conditional Access. Use that licensing to create an exception for the HVE identity—not for the tenant.

1. Create a dedicated HVE account, for example `hve-konica-c3351@contoso.com`. Do not reuse a person's mailbox, a Global Administrator account, or a shared administrative credential.
2. Give the account a long, unique password stored in the approved password manager. Do not use the HVE account for interactive work, Microsoft 365 administration, or other applications.
3. Create or update the Conditional Access baseline before changing Security Defaults. Include at least protections for MFA for users and administrators, legacy-authentication blocking, and emergency-access accounts.
4. Place the HVE account in a clearly named exception group, for example `CA - HVE Basic SMTP - Exclude`. Keep the group limited to HVE accounts that have a documented business requirement for basic SMTP.
5. Exclude that group only from the Conditional Access policies that would otherwise prevent the HVE basic SMTP connection:
   - policies that **require MFA** for the HVE account; and
   - policies that **block legacy authentication** or target legacy/other client applications.
6. Do not exclude the HVE account from unrelated protection policies unless testing shows a specific, documented need. Review every exclusion during the tenant's scheduled Conditional Access review.
7. Confirm emergency access accounts exist and can sign in before changing tenant-wide authentication controls.
8. Disable Security Defaults, then enable the reviewed Conditional Access policies. Validate user and administrator sign-ins before enabling the copier exception in production.

Conditional Access policies can be targeted to users and groups, with exclusions. Security Defaults cannot. That is why Conditional Access is the appropriate replacement when a narrow basic-auth exception is unavoidable.

## Disable Security Defaults only during the transition

After the Conditional Access policy design and emergency-access testing are complete:

1. Sign in to the [Microsoft Entra admin center](https://entra.microsoft.com) as at least a **Conditional Access Administrator**.
2. Go to **Entra ID** > **Overview** > **Properties**.
3. Select **Manage security defaults**.
4. Set **Security defaults** to **Disabled**.
5. Select **Save**.
6. Immediately confirm the intended Conditional Access policies are enabled and scope them as reviewed.

Microsoft recommends two cloud-only emergency access accounts permanently assigned the Global Administrator role. Exclude and test those accounts deliberately; do not use the copier HVE account as an emergency account.

## Configure the HVE account and Exchange authentication policy

Create the HVE account in the [Exchange admin center](https://admin.exchange.microsoft.com) under **Mail flow** > **High Volume Email** > **Add an HVE account**, or use the approved Exchange Online PowerShell workflow.

If the tenant uses Exchange authentication policies that block SMTP basic authentication, assign a custom policy to the HVE account that enables **only** `AllowBasicAuthSmtp`. New Exchange authentication policies block basic authentication for all protocols by default, so the SMTP allowance must be explicit.

```powershell
# Connect to Exchange Online PowerShell first.
New-AuthenticationPolicy -Name "HVE Allow Basic SMTP" -AllowBasicAuthSmtp

Set-User -Identity hve-konica-c3351@contoso.com `
  -AuthenticationPolicy "HVE Allow Basic SMTP"

Get-AuthenticationPolicy -Identity "HVE Allow Basic SMTP" |
  Format-List Name,AllowBasicAuthSmtp

Get-User -Identity hve-konica-c3351@contoso.com |
  Format-List Name,AuthenticationPolicy
```

Authentication-policy changes can take time to apply. To request an earlier refresh for the HVE account, use the approved change window and run:

```powershell
Set-User -Identity hve-konica-c3351@contoso.com `
  -STSRefreshTokensValidFrom $([System.DateTime]::UtcNow)
```

Do **not** enable normal Exchange Online SMTP AUTH tenant-wide to solve an HVE problem. HVE uses a dedicated SMTP endpoint and can authenticate even when `SmtpClientAuthenticationDisabled` in `TransportConfig` is `True`. Keep that broader control in its approved secure state unless another separately documented requirement exists.

## Configure the copier or scanner

For an HVE account using basic SMTP authentication, configure the device with:

| Device setting | Value |
| --- | --- |
| SMTP server / smart host | `smtp.hve.mx.microsoft` |
| Port | `587` |
| Encryption | TLS or STARTTLS enabled |
| Authentication | HVE account username and password (SMTP LOGIN/basic authentication) |
| Username | Dedicated HVE account, for example `hve-konica-c3351@contoso.com` |
| From address | The HVE account's approved primary SMTP address |

`smtp-hve.office365.com` remains available for some configurations but is scheduled for deprecation. Use `smtp.hve.mx.microsoft` for new or updated configurations.

## Validate the configuration

1. Send a test scan to an internal recipient in an accepted domain.
2. Confirm the message arrives and records the HVE sender address.
3. Review the HVE account in Exchange admin center and confirm it has a valid billing policy, where required.
4. Check Microsoft Entra sign-in logs for the HVE account and confirm the expected Conditional Access exclusion was applied. Investigate any unexpected policy exclusion before closing the change.
5. Confirm a standard user remains subject to MFA and that a standard legacy-authentication attempt is blocked.
6. Record the device, HVE account, exception group, Conditional Access policy IDs, Change ticket, and test result in the client documentation.

## Troubleshooting

| Symptom | Likely cause | Corrective action |
| --- | --- | --- |
| Copier returns `535 5.7.3` or `535 5.7.139` | Security Defaults is still enabled, or a Conditional Access policy is blocking the HVE basic-auth sign-in | Confirm Security Defaults is disabled only after Conditional Access replacement is active; review the HVE account's Conditional Access results and exclusions. |
| HVE authentication fails after Security Defaults is disabled | The HVE account is covered by an Exchange authentication policy that blocks SMTP basic auth | Assign a dedicated policy with `AllowBasicAuthSmtp` enabled, then allow time for it to apply. |
| Technician wants to set `SmtpClientAuthenticationDisabled` to `False` | HVE is being confused with ordinary SMTP AUTH | Do not change it for HVE. Verify the copier uses the HVE endpoint and HVE account. |
| Scan-to-email works internally but not externally | HVE does not relay to external recipients | Use a supported relay or mail-flow design for external delivery; do not treat HVE as an Internet SMTP relay. |
| HVE account has no valid billing policy | The account is not associated with an active HVE billing policy | Review the HVE account's billing policy in Exchange admin center and resolve the associated Azure subscription or policy issue. |

## Security review checklist

- [ ] HVE account is dedicated to one device or documented application purpose.
- [ ] HVE account is not an administrator and is not used interactively.
- [ ] Password is unique, long, and stored only in the approved password manager and device configuration.
- [ ] Security Defaults is disabled only because equivalent Conditional Access protections are in place.
- [ ] HVE exception group is excluded only from required MFA and legacy-authentication policies.
- [ ] Exchange authentication policy permits only `AllowBasicAuthSmtp` for the HVE account.
- [ ] Normal Exchange SMTP AUTH remains disabled tenant-wide unless separately approved.
- [ ] Device is restricted to its approved network and monitored through normal device-management practices.
- [ ] HVE account, Conditional Access exclusions, and test results are recorded in the customer configuration record.

## Microsoft references

- [Manage High Volume Email for Microsoft 365](https://learn.microsoft.com/en-us/exchange/mail-flow-best-practices/high-volume-mails-m365)
- [Troubleshoot High Volume Email for Microsoft 365](https://learn.microsoft.com/en-us/exchange/mail-flow-best-practices/troubleshoot-high-volume-email-m365)
- [Configure Security Defaults for Microsoft Entra ID](https://learn.microsoft.com/en-us/entra/fundamentals/security-defaults)
- [Disable Basic authentication in Exchange Online](https://learn.microsoft.com/en-us/exchange/clients-and-mobile-in-exchange-online/disable-basic-authentication-in-exchange-online)
