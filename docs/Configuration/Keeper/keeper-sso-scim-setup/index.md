---
title: Keeper SSO + SCIM Setup with Microsoft Entra ID
seo_title: Keeper Password Manager SSO + SCIM Setup with Microsoft Entra ID
description: A practical MSP guide to configuring Keeper Password Manager with Microsoft Entra ID SSO and SCIM provisioning. Covers prerequisites, common pitfalls, and troubleshooting.
keywords: keeper password manager, keeper scim, keeper sso, entra id, azure ad, scim provisioning, sso connect cloud, keeper enterprise, msp password management
canonical: https://help.svetek.com/docs/Configuration/Keeper/keeper-sso-scim-setup/
og_title: Keeper SSO + SCIM Setup with Microsoft Entra ID
og_description: A practical MSP guide to configuring Keeper Password Manager with Microsoft Entra ID SSO and SCIM provisioning. Covers prerequisites, common pitfalls, and troubleshooting.
og_type: article
og_image: https://help.svetek.com/images/svetek-favicon.png
og_locale: en_US
og_site_name: Svetek Documentation
og_url: https://help.svetek.com/docs/Configuration/Keeper/keeper-sso-scim-setup/
og_updated_time: 2026-06-06T00:00:00+00:00
published_time: 2026-06-06T00:00:00+00:00
twitter_card: summary_large_image
twitter_domain: help.svetek.com
twitter_site: "@svetekITexperts"
twitter_title: Keeper SSO + SCIM Setup with Microsoft Entra ID
twitter_description: A practical MSP guide to configuring Keeper Password Manager with Microsoft Entra ID SSO and SCIM provisioning.
twitter_image: https://help.svetek.com/images/svetek-favicon.png
twitter_image_alt: Svetek Documentation
twitter_url: https://x.com/svetekITexperts
redirect_from:
  - /docs/Configuration/Keeper/keeper-sso-scim-setup-msp-vancouver-portland-seattle/
layout: docs
---

<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "HowTo",
  "name": "Configure Keeper Password Manager with Microsoft Entra ID SSO and SCIM",
  "description": "A practical MSP guide to configuring Keeper Password Manager with Microsoft Entra ID SSO and SCIM provisioning. Covers prerequisites, common pitfalls, and troubleshooting.",
  "step": [
    {
      "@type": "HowToSection",
      "name": "Before You Start",
      "step": [
        { "@type": "HowToStep", "text": "Reserve the client's email domain with Keeper support before any other step." },
        { "@type": "HowToStep", "text": "Confirm SCIM and SSO Connect Cloud will be configured on a subnode, not the root node." }
      ]
    },
    {
      "@type": "HowToSection",
      "name": "SSO Setup",
      "step": [
        { "@type": "HowToStep", "text": "In Entra ID, create a new Enterprise Application for Keeper Password Manager and Digital Vault." },
        { "@type": "HowToStep", "text": "In the Keeper Admin Console, navigate to the target subnode and add SSO Connect Cloud as a provisioning method." },
        { "@type": "HowToStep", "text": "Export SAML metadata from Keeper and upload it to Entra ID." },
        { "@type": "HowToStep", "text": "Test SSO with a non-admin test user before rolling out." }
      ]
    },
    {
      "@type": "HowToSection",
      "name": "SCIM Setup",
      "step": [
        { "@type": "HowToStep", "text": "In the Keeper Admin Console, add SCIM as a provisioning method on the same subnode as SSO." },
        { "@type": "HowToStep", "text": "Generate a provisioning token and copy the Tenant URL and Secret Token." },
        { "@type": "HowToStep", "text": "In Entra ID, go to the Keeper Enterprise App, set provisioning to Automatic, paste the Tenant URL and Secret Token, save, then test the connection." },
        { "@type": "HowToStep", "text": "Assign both groups and individual users to the Keeper app in Entra ID." },
        { "@type": "HowToStep", "text": "Ensure no assigned users have the Default Access role." },
        { "@type": "HowToStep", "text": "Start provisioning and wait 5–40 minutes for the first sync." }
      ]
    },
    {
      "@type": "HowToSection",
      "name": "Post-Provisioning",
      "step": [
        { "@type": "HowToStep", "text": "Disable JIT provisioning on the SSO Connect Cloud config to avoid conflict with SCIM." },
        { "@type": "HowToStep", "text": "Approve pending teams via Full Sync in Keeper Admin Console, or deploy Keeper Automator for automatic approval." }
      ]
    }
  ]
}
</script>

<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "FAQPage",
  "mainEntity": [
    {
      "@type": "Question",
      "name": "Team was created in Keeper but has no users. What is the cause?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "The client's email domain has not been reserved with Keeper. Submit a support ticket at keepersecurity.servicenowservices.com to request domain reservation before proceeding."
      }
    },
    {
      "@type": "Question",
      "name": "Entra ID provisioning logs show a 412 PreconditionFailed error.",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "This error means the client's email domain has not been reserved with Keeper. Submit a support ticket to Keeper to reserve the domain."
      }
    },
    {
      "@type": "Question",
      "name": "Users are being skipped in the Entra ID provisioning logs.",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "The affected users likely have the Default Access role in Entra ID. Assign a valid app role to each user in Entra ID."
      }
    },
    {
      "@type": "Question",
      "name": "Users are being prompted for a Master Password instead of SSO.",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "The user is assigned to the root node rather than the SSO-enabled subnode. Move the user to the correct subnode."
      }
    },
    {
      "@type": "Question",
      "name": "The Test Connection button fails before the provisioning token is saved.",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "Always save the Tenant URL and Secret Token before clicking Test Connection. Testing before saving will always fail."
      }
    },
    {
      "@type": "Question",
      "name": "Teams are stuck in Pending state after SCIM provisioning.",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "Keeper requires an authenticated user to approve team assignments due to its zero-knowledge model. Run Full Sync in the Keeper Admin Console, or deploy Keeper Automator v3.2+ for automatic approval."
      }
    },
    {
      "@type": "Question",
      "name": "JIT and SCIM are both active and provisioning is behaving inconsistently.",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "JIT and SCIM conflict when both are enabled. Disable JIT on the SSO Connect Cloud configuration so SCIM is the sole provisioning method."
      }
    }
  ]
}
</script>

<!--
  ONE-TIME TEMPLATE FIX REQUIRED (_includes/head.html):
  Find the <title> tag and change it from:
    <title>{{ page.title }}</title>
  to:
    <title>{{ page.seo_title | default: page.title }}</title>
  This renders seo_title in the browser tab / search engine results,
  while the clean title field is used as the visible H1 on the page.
  No changes needed to _layouts/docs.html.
-->

*A field guide for MSPs deploying Keeper Password Manager with Entra ID SSO and SCIM provisioning — with lessons learned from real-world implementations serving businesses in Vancouver, WA, Portland, OR, and Seattle, WA.*

---

## Why Use SCIM With Keeper?

When deploying Keeper for a client who already uses Microsoft Entra ID (formerly Azure AD), you have two provisioning options: Just-in-Time (JIT) or SCIM. Understanding the difference will help you choose the right approach — and justify it to the client.

### JIT (Just-in-Time) Provisioning

JIT creates a Keeper vault for a user the first time they log in via SSO. It's simple and requires no additional configuration beyond SSO setup. However, it has meaningful gaps for business use:

- No user exists in Keeper until they personally log in for the first time
- No way to pre-assign shared folders or team memberships before first login
- No automatic deprovisioning — a terminated employee's vault stays active until manually locked
- No group/team sync from Entra ID

### SCIM Provisioning

SCIM (System for Cross-domain Identity Management) connects Entra ID to Keeper continuously, syncing users and groups automatically. For most business clients, SCIM is the right choice because it provides:

- **Pre-provisioning** — user accounts and team memberships are ready before the employee ever logs in, so shared folders are available on day one
- **Entra ID group → Keeper Team sync** — security groups in Entra ID become Teams in Keeper, giving access to shared vaults automatically
- **Automatic deprovisioning** — when a user is disabled or removed in Entra ID, their Keeper vault is locked immediately, closing a critical offboarding security gap
- **Lifecycle management** — name changes and profile updates in Entra ID flow through to Keeper automatically
- **Consistent onboarding** — new hires get the right shared folder access from day one without any manual admin work in Keeper

> **Recommendation:** Use SCIM for any client with more than a handful of users, active offboarding needs, or shared vault/team requirements. Use JIT-only for very small clients with simple needs and no shared folder structure.

---

## Before You Start

### 1. Reserve the Client's Email Domain with Keeper ⚠️

This is the single most common deployment blocker and must be done **before** configuring SCIM. Without it, every user provisioning attempt will silently fail with a `412 PreconditionFailed` error — while teams/groups are still created, making it appear SCIM is partially working.

- Open a support ticket with Keeper via their helpdesk portal: https://keepersecurity.servicenowservices.com/
- Request domain reservation for SCIM provisioning
- Provide the client's email domain (e.g. `clientdomain.com`) and their Keeper tenant details
- **Do not proceed with SCIM setup until Keeper confirms the domain is reserved**

> ℹ️ This requirement is not prominently documented in Keeper's official SCIM setup guide — it is easy to miss and will cost significant troubleshooting time if skipped.

### 2. Use a Subnode, Not the Root Node

- SCIM and SSO Connect Cloud must both be configured on a **subnode**, not the root node
- Users placed in the root node will be prompted for a Master Password instead of SSO
- Admins cannot move themselves to an SSO-enabled node — a second admin must do it
- Keep at least one admin at the root node with Master Password login as a **break-glass account** in case Entra ID / Microsoft goes down

---

## SSO Setup (Entra ID / Azure AD)

1. In Entra ID, create a new Enterprise Application — search for **Keeper Password Manager & Digital Vault**
2. In the Keeper Admin Console, navigate to the target **subnode** → Provisioning → Add Method → **SSO Connect Cloud**
3. Export the SAML metadata from Keeper and upload it into Entra ID
4. Complete SSO configuration and test with a **non-admin test user** before rolling out to the client

---

## SCIM Setup (Entra ID / Azure AD)

> SSO must be configured first. Both SSO Connect Cloud and SCIM must be on the **same subnode**.

1. In the Keeper Admin Console, go to the same subnode → Provisioning → Add Method → **SCIM**
2. Generate a provisioning token — copy the **Tenant URL** and **Secret Token**
3. In Entra ID, go to the Keeper Enterprise App → Provisioning → set to **Automatic**
4. Paste the Tenant URL and Secret Token → **Save first**, then Test Connection
   > ⚠️ Do not click Test Connection before saving — it will fail
5. Under **Users and Groups**, assign both the **group(s)** and the **individual users** to the Keeper app
   > Assigning only the group is not sufficient — individual users must also be explicitly assigned to the app
6. Ensure assigned users do not have the **Default Access** role in Entra ID — those users are excluded from provisioning
7. Click **Start Provisioning** in Entra ID
8. Wait 5–40 minutes (Microsoft's first sync can be slow), then click **Sync** in the Keeper Admin Console

---

## Critical: Disable JIT When Using SCIM

- If SSO Connect Cloud has **Just-in-Time (JIT) provisioning** enabled, it will conflict with SCIM
- Go to the SSO Connect Cloud config on the subnode and **disable JIT** before activating SCIM
- With JIT disabled, SCIM becomes the sole provisioning method — this is the correct and stable configuration

---

## Teams and User Approvals (Post-Provisioning)

SCIM-provisioned teams and user-team assignments go into a **Pending Queue** in Keeper due to its zero-knowledge encryption model — private keys must be shared by an authenticated user and cannot be handled server-side. Teams will not be fully active until one of the following occurs:

- Admin clicks **Full Sync** in the Keeper Admin Console
- An existing team member logs into the Web Vault or Desktop App
- Admin runs `team-approve` via Keeper Commander CLI
- **Recommended:** Deploy the **Keeper Automator service** (v3.2+) for instant automatic approval without any manual intervention

---

## Verifying Provisioning is Working

1. In Entra ID → Keeper App → **Provisioning → Provision on demand** → select a test user and run
2. Check the result immediately — errors (domain not reserved, role exclusions, etc.) are shown here with specific detail
3. In the Keeper Admin Console → subnode → **Users tab** — provisioned users should appear in **Invited** state
4. Since SSO is enabled, users will **not** receive a traditional email invite — direct them to log in via `https://myapplications.microsoft.com` and click the Keeper icon

---

## Troubleshooting Reference

| Symptom | Likely Cause | Fix |
|---|---|---|
| Team created in Keeper but no users | Domain not reserved with Keeper | Submit ticket at keepersecurity.servicenowservices.com |
| `412 PreconditionFailed` in Entra logs | Domain not reserved | Submit ticket at keepersecurity.servicenowservices.com |
| Users skipped in Entra provisioning logs | User has "Default Access" role | Assign a valid app role in Entra ID |
| Users prompted for Master Password | User is in root node, not SSO subnode | Move user to SSO-enabled subnode |
| Test Connection fails before saving | Token not saved before testing | Save token first, then test |
| Teams stuck in Pending state | No authenticated user to approve | Run Full Sync, or deploy Keeper Automator |
| JIT and SCIM both enabled | Provisioning conflict | Disable JIT on the SSO Connect Cloud config |
| User provisioning fails after account recreated in Keeper | Enterprise User ID mismatch | Unassign and reassign user in Entra ID |

---

## Support & Resources

- **Keeper Helpdesk (Support Tickets):** https://keepersecurity.servicenowservices.com/
- **Keeper Docs — Entra ID SCIM:** https://docs.keeper.io/en/enterprise-guide/user-and-team-provisioning/azure-ad-provisioning-scim
- **Keeper Docs — SSO Connect Cloud:** https://docs.keeper.io/sso-connect-cloud
- **Keeper Automator:** https://keeper.io/automator
- **Keeper Commander CLI:** https://docs.keeper.io/en/enterprise-guide/commander-cli

---
