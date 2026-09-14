---
title: "Configure the Claude Microsoft 365 Connector"
seo_title: "Configure Claude Microsoft 365 Connector in Entra ID | MSP Guide"
description: "Technician procedure to configure, restrict, validate, and manage the Claude Microsoft 365 connector with Microsoft Entra ID delegated access."
keywords: "Claude Microsoft 365 connector, Claude Entra ID setup, M365 MCP Client for Claude, M365 MCP Server for Claude, Claude Microsoft Graph consent, Claude Microsoft 365 security"
canonical: https://help.svetek.com/docs/Configuration/Microsoft_365/claude-microsoft-365-connector/
og_title: "Configure the Claude Microsoft 365 Connector"
og_description: "Set up Claude's Microsoft 365 connector with Entra consent, assignment-required access, validation, and ongoing review."
og_type: article
og_image: https://help.svetek.com/images/logo_horizontal_whitetext.svg
og_url: https://help.svetek.com/docs/Configuration/Microsoft_365/claude-microsoft-365-connector/
published_time: 2026-09-09T00:00:00+00:00
date: 2026-09-09
tags:
  - Claude
  - Microsoft 365
  - Microsoft Entra
  - Enterprise Applications
  - Microsoft Graph
twitter_title: "Configure Claude Microsoft 365 Connector"
twitter_description: "Configure and restrict Claude's Microsoft 365 connector in Microsoft Entra ID."
twitter_image: https://help.svetek.com/images/logo_horizontal_whitetext.svg
twitter_image_alt: "Svetek logo"
layout: docs
---

Use this procedure to authorize Claude's Microsoft 365 connector in a Microsoft Entra tenant and limit it to approved users. The connector uses **delegated** Microsoft Graph access: Claude acts as the user who connects it and can access only Microsoft 365 content that user can already access.

This is an administrator procedure. Users should follow [Connect Claude to Microsoft 365](/docs/Guides/OtherGuides/connect-claude-microsoft-365/) only after this setup is complete.

## What this configuration creates

The connector requires two Microsoft Entra enterprise applications:

- **M365 MCP Client for Claude** — application ID `08ad6f98-a4f8-4635-bb8d-f1a3044760f0`
- **M365 MCP Server for Claude** — application ID `07c030f6-5743-41b7-ba00-0a6e85f37c17`

Use the following access model:

1. Create one dedicated **security group** for people approved to use the connector. Use the tenant's normal naming standards; this guide does not prescribe a group name.
2. Set **Assignment required?** to **Yes** on both enterprise applications.
3. Assign the same security group to both applications.
4. Add or remove users through that group.

Do not use an administrator's Microsoft 365 account in an end user's Claude session. Administrative consent is completed separately; each user signs in to Microsoft 365 with their own work account.

## Prerequisites and decisions

Before beginning, confirm the following:

- The intended users have active Microsoft 365 work accounts tied to a Microsoft Entra tenant. Personal Microsoft accounts are not supported.
- A Microsoft Entra **Global Administrator** is available to grant tenant-wide consent.
- For Claude Team or Enterprise, a Claude organization Owner can enable the connector in Claude. On Free, Pro, and Max, this organization-level Claude step is not required.
- The tenant can create a security group and assign it to enterprise applications. Microsoft Entra ID P1 is required for group-based enterprise-application assignment; if it is unavailable, assign approved users directly to **both** applications and maintain the same access set manually.
- The requester and data owner approve the Microsoft Graph permissions displayed in the consent prompt.
- The initial deployment is **read-only** unless there is a documented need for write tools.

> **Scope warning:** The connector follows the user's existing permissions. It can search Microsoft 365 resources that the user is already allowed to access, including SharePoint, OneDrive, Outlook, Teams, and shared mailboxes where the user has delegate access. It cannot be restricted to a specific SharePoint site with `Sites.Selected`.

## 1. Enable the connector in Claude when required

This step applies only to Claude Team and Enterprise plans.

1. Sign in to Claude as a Claude organization Owner.
2. Go to **Organization settings** > **Connectors**.
3. Select **Add**, choose **All available**, find **Microsoft 365**, and select **Add to your team**.

For Free, Pro, and Max plans, skip this step. The Microsoft Entra consent and access restriction steps below still apply.

## 2. Add the two enterprise applications

First, check **Microsoft Entra admin center** > **Enterprise applications** > **All applications** for both application names. If an application already exists, do not create a duplicate; continue with the missing application or with consent and restriction.

If either application is absent, add it through [Microsoft Graph Explorer](https://developer.microsoft.com/graph/graph-explorer):

1. Sign in to Graph Explorer with an authorized Entra administrator account and select the intended tenant.
2. Set the method to `POST` and enter this request for the client application:

   ```http
   https://graph.microsoft.com/v1.0/servicePrincipals
   ```

   ```json
   {"appId":"08ad6f98-a4f8-4635-bb8d-f1a3044760f0"}
   ```

3. Run the request. Confirm the response identifies **M365 MCP Client for Claude**.
4. Repeat the same request for the server application:

   ```json
   {"appId":"07c030f6-5743-41b7-ba00-0a6e85f37c17"}
   ```

5. Confirm both applications now appear under **Enterprise applications**.

## 3. Grant Microsoft Entra administrator consent

Grant consent from a separate administrator browser session, not from the user's Claude session.

1. Obtain the tenant ID from **Microsoft Entra admin center** > **Overview**.
2. Open each URL below, replacing `<tenant-id>` with the tenant ID. Sign in as a Global Administrator.

   ```text
   https://login.microsoftonline.com/<tenant-id>/adminconsent?client_id=08ad6f98-a4f8-4635-bb8d-f1a3044760f0
   ```

   ```text
   https://login.microsoftonline.com/<tenant-id>/adminconsent?client_id=07c030f6-5743-41b7-ba00-0a6e85f37c17
   ```

3. Review the permissions requested by each prompt before accepting it.
4. In **Enterprise applications**, open each Claude application and review **Permissions** to confirm the expected administrator consent is present.

Do not approve a later consent request automatically. Review new scopes, the requested business function, and the resulting data exposure before granting additional consent.

## 4. Restrict connector access to approved users

Create a dedicated Entra security group for approved connector users, then apply the same group to both applications.

1. In **Microsoft Entra admin center** > **Identity** > **Groups** > **All groups**, create a **Security** group.
2. Add only the approved users to the group.
3. Go to **Enterprise applications** > **M365 MCP Server for Claude** > **Properties**.
4. Set **Assignment required?** to **Yes**, then save.
5. Open **Users and groups** > **Add user/group** and assign the dedicated security group.
6. Repeat steps 3–5 for **M365 MCP Client for Claude**.

Both applications must have **Assignment required? = Yes** and the same approved group assignment. A user assigned to only one application may be unable to complete the connector flow.

## 5. Keep the initial permission set read-only

The standard connector setup is read-only. It can search and analyze supported Microsoft 365 data the signed-in user can already access.

Do not enable write tools as part of the initial deployment unless the requester has approved the additional risk. Write tools can send email, manage calendar events, update mailbox settings, and create or update files within the user's existing permissions.

If the tenant needs less access than the default connector permission set:

1. Open **Enterprise applications** > **M365 MCP Server for Claude** > **Permissions**.
2. On the **Admin consent** tab, review the Microsoft Graph scopes.
3. Revoke only a permission whose business impact has been reviewed and accepted.
4. Test the affected connector function with an approved user.

Revoking a scope causes related Claude requests to fail. Re-running the documented administrator-consent flow restores the default permission set, so record any intentional scope restrictions before re-consenting.

## 6. Enable write tools only when approved

Complete all of the following before enabling write tools:

1. Obtain documented approval for the write capabilities required.
2. Have a Global Administrator review and consent to the updated Microsoft Graph permission set.
3. In Claude, have a Claude organization Owner enable the Microsoft 365 write tools for the appropriate organization members. Use role-based access controls where the Claude plan supports them.
4. Test a low-risk action, such as drafting an email without sending it, using an approved pilot user.

Do not treat write tools as a substitute for Microsoft 365 authorization. Claude still acts within the user's existing access, but the connector introduces a new way to create, update, or send content.

## Validation

Complete these checks before closing the change:

- [ ] Both Claude enterprise applications exist.
- [ ] Tenant-wide administrator consent has been reviewed and granted for both applications.
- [ ] **Assignment required?** is **Yes** on both applications.
- [ ] The same approved security group is assigned to both applications, or the same intended users are directly assigned to both when group assignment is unavailable.
- [ ] An approved pilot user connects using their own Microsoft 365 work account.
- [ ] A read-only search returns only data that the pilot user can access directly in Microsoft 365.
- [ ] An unapproved test user cannot complete connector authentication.
- [ ] If write tools were approved, the pilot test produced the expected result and no more.
- [ ] No administrator credentials were entered in the pilot user's Claude session.

## Conditional Access and sign-in troubleshooting

Conditional Access can allow the user's interactive browser sign-in but block the connector's later server-side token exchange. Do not solve this by broadly excluding the connector or disabling Conditional Access.

When authentication fails:

1. Confirm the user has an active Microsoft 365 work account and is assigned to both applications.
2. Confirm consent exists for both applications.
3. In **Microsoft Entra admin center** > **Sign-in logs**, review the user's **non-interactive** sign-ins as well as interactive sign-ins.
4. Open a failed event and review the **Conditional Access** tab, the error code, and the affected application.
5. Test a narrowly scoped policy change in report-only mode or with a pilot before enforcing it broadly.

Anthropic publishes current Conditional Access behavior and any required network considerations in its connector documentation. Review that guidance before adding named-location or sign-in-frequency exceptions.

| Symptom | Likely cause | Corrective action |
| --- | --- | --- |
| User cannot authenticate | Missing tenant-wide consent, missing app assignment, personal Microsoft account, or Conditional Access block | Confirm the user and both app assignments, then review Entra sign-in logs. |
| Connector cannot retrieve expected content | User does not have direct Microsoft 365 access, or a required scope was revoked | Verify the user can open the content directly, then review granted permissions. |
| Claude shows a tool failure | The related Graph scope was revoked or the content type is unsupported | Check the enterprise-application permissions and current Anthropic connector limits. |
| Write tools do not appear | Updated consent or Claude organization enablement is incomplete | Review the updated scopes and Claude write-tool settings, then reconnect the user. |

## Monitoring and ongoing management

Review this integration at least quarterly and after any connector permission change:

- Review membership of the dedicated access group and remove users without a current business need.
- Review **Users and groups** and **Properties** on both enterprise applications for unexpected direct assignments or a disabled assignment requirement.
- Review administrator consent and Microsoft Graph permissions. Do not automatically approve newly requested permissions.
- Review Entra sign-in and audit logs for unexpected users, repeated failures, Conditional Access failures, risky sign-ins, consent changes, group membership changes, and enterprise-application changes.
- Reassess the connector after Anthropic changes its Microsoft 365 feature set, write capabilities, permissions, or Conditional Access guidance.

## Offboarding and rollback

To remove one user's access, remove the user from the dedicated security group. If direct user assignments are used, remove the user from **both** enterprise applications. Ask the user to disconnect Microsoft 365 from Claude; if immediate termination is required, also revoke the user's Entra sessions according to the tenant's offboarding procedure.

To remove the connector from the tenant, first confirm the business owner has approved the change and no approved users still depend on it. Then remove access assignments, remove or revoke consent as appropriate, and remove the two enterprise applications. Removing tenant-wide consent or the applications affects every connected user.

## References

- [Anthropic: Set up the Microsoft 365 connector](https://support.claude.com/en/articles/12542951-set-up-the-microsoft-365-connector)
- [Anthropic: Connect to Microsoft 365](https://support.claude.com/en/articles/15183774-connect-to-microsoft-365)
- [Microsoft: Grant tenant-wide admin consent](https://learn.microsoft.com/en-us/entra/identity/enterprise-apps/grant-admin-consent)
- [Microsoft: Manage access to enterprise applications with groups](https://learn.microsoft.com/en-us/entra/identity/users/directory-overview-user-model)
