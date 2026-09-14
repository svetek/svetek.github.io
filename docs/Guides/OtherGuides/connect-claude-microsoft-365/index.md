---
title: "Connect Claude to Microsoft 365"
seo_title: "Connect Claude to Microsoft 365 | User Guide"
description: "End-user steps for connecting a Claude account to an approved Microsoft 365 work account after IT has configured the Microsoft 365 connector."
keywords: "connect Claude Microsoft 365, Claude Outlook OneDrive Teams connector, Claude Microsoft 365 user guide, Claude work account"
canonical: https://help.svetek.com/docs/Guides/OtherGuides/connect-claude-microsoft-365/
og_title: "Connect Claude to Microsoft 365"
og_description: "Connect your approved Microsoft 365 work account to Claude and control or disconnect the connector when needed."
og_type: article
og_image: https://help.svetek.com/images/logo_horizontal_whitetext.svg
og_url: https://help.svetek.com/docs/Guides/OtherGuides/connect-claude-microsoft-365/
published_time: 2026-09-09T00:00:00+00:00
date: 2026-09-09
tags:
  - Claude
  - Microsoft 365
  - User Guide
twitter_title: "Connect Claude to Microsoft 365"
twitter_description: "Connect your approved Microsoft 365 work account to Claude."
twitter_image: https://help.svetek.com/images/logo_horizontal_whitetext.svg
twitter_image_alt: "Svetek logo"
layout: docs
---

Use this guide after IT confirms that your organization has enabled and approved the Claude Microsoft 365 connector for your account.

## Before you begin

You need:

- an approved Claude account;
- an active Microsoft 365 **work** account; and
- confirmation from IT that you are approved to use the connector.

Do not use a personal Microsoft account such as an `@outlook.com`, `@hotmail.com`, or `@live.com` address. Do not use an IT administrator's Microsoft 365 account.

## Connect your work account

1. Sign in to [Claude](https://claude.ai/) with your own Claude account.
2. Open **Customize** > **Connectors**.
3. Find **Microsoft 365** and select **Connect**.
4. When Microsoft opens, sign in with your own work account and complete any normal sign-in or MFA prompts.
5. Complete the Microsoft consent and return to Claude.
6. Confirm Microsoft 365 shows as connected in **Customize** > **Connectors**.

After the initial connection, the connector is also available when you use the same Claude account on Claude mobile apps.

## What Claude can access

Claude uses your existing Microsoft 365 permissions. It can access only data you can already access directly in Microsoft 365, such as permitted Outlook messages, OneDrive files, SharePoint content, Teams conversations, and shared mailboxes where you have delegate access.

Claude accesses Microsoft 365 data when you make a request that needs it. It does not give you access to content you could not already open yourself.

By default, the connector is read-only. If IT has specifically enabled write tools, Claude may be able to perform actions such as drafting or sending email, managing calendar events, or creating and updating files within your existing Microsoft 365 permissions.

## Control or disconnect the connector

To turn individual Microsoft 365 tools on or off:

1. Go to **Customize** > **Connectors**.
2. Select **Microsoft 365**.
3. Change the appropriate **Tool permissions** toggle.

To disconnect Microsoft 365 completely:

1. Go to **Customize** > **Connectors**.
2. Find **Microsoft 365** under connected services.
3. Select **Disconnect**.

Disconnecting removes Claude's access to your Microsoft 365 data. You can reconnect later if IT approval and tenant consent remain active.

## If you cannot connect

| Issue | What to do |
| --- | --- |
| Microsoft rejects the sign-in | Confirm you used your Microsoft 365 work account, then contact IT. |
| Claude says an administrator must approve the app | Contact IT. The tenant-wide connector setup or your access assignment may not be complete. |
| Claude cannot find a file or message | First confirm you can access it directly in Microsoft 365. Recently added content may not be searchable immediately. |
| A connector tool fails | Contact IT with the time of the error and a screenshot. Do not share passwords, MFA codes, or sensitive content in the support request. |

## Need help?

Contact IT if you were not expecting to see this connector, cannot complete the Microsoft sign-in, or no longer need access.

## Reference

- [Anthropic: Connect to Microsoft 365](https://support.claude.com/en/articles/15183774-connect-to-microsoft-365)
