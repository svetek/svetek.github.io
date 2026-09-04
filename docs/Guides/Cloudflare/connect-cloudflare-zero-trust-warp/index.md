---
title: "Connect a Device to Cloudflare Zero Trust with Cloudflare One Client"
seo_title: "Connect to Cloudflare Zero Trust with WARP | User Guide"
description: "End-user instructions to download the Cloudflare One Client (WARP), sign in to a Cloudflare Zero Trust organization with an email one-time PIN, and confirm the device is connected."
keywords: "Cloudflare WARP user guide, Cloudflare One Client download, Cloudflare Zero Trust team name, WARP email one-time PIN, connect WARP Windows Mac"
canonical: https://help.svetek.com/docs/Guides/Cloudflare/connect-cloudflare-zero-trust-warp/
og_title: "Connect a Device to Cloudflare Zero Trust with Cloudflare One Client"
og_description: "Download the Cloudflare One Client, enter your team name, and sign in with the email code provided by your organization."
og_type: article
og_image: https://help.svetek.com/images/logo_horizontal_whitetext.svg
og_url: https://help.svetek.com/docs/Guides/Cloudflare/connect-cloudflare-zero-trust-warp/
published_time: 2026-09-04T00:00:00+00:00
date: 2026-09-04
tags:
  - Cloudflare Zero Trust
  - Cloudflare One Client
  - WARP
  - User Guide
twitter_title: "Connect to Cloudflare Zero Trust"
twitter_description: "End-user steps to install Cloudflare One Client and connect to your organization's Cloudflare Zero Trust service."
twitter_image: https://help.svetek.com/images/logo_horizontal_whitetext.svg
twitter_image_alt: "Svetek logo"
layout: docs
---

Use this guide to connect your computer or mobile device to your organization's Cloudflare Zero Trust service. You will install the **Cloudflare One Client** (formerly called WARP), enter the team name provided by IT, and sign in using the method your organization has configured.

If your organization uses Microsoft Entra ID (Azure AD), sign in with your Microsoft work account. You do **not** need a Cloudflare email one-time PIN, although Microsoft may still ask you to complete its normal MFA prompt. Use the email PIN instructions only when IT directs you to use **One-time PIN**.

## Before you begin

You need:

- your organization's Cloudflare Zero Trust **team name** from IT;
- access to the email address IT approved for you; and
- permission to install software on the device, or help from IT.

Your team name is not your email domain. Enter it exactly as provided by IT.

## Download the Cloudflare One Client

For Windows, download the Cloudflare One Client (WARP) from Cloudflare's official [Windows download page](https://developers.cloudflare.com/cloudflare-one/team-and-resources/devices/cloudflare-one-client/download/#windows). For other operating systems, use Cloudflare's [Cloudflare One Client download page](https://developers.cloudflare.com/cloudflare-one/team-and-resources/devices/cloudflare-one-client/download/).

Install the downloaded application using the normal prompts for your device. The app may appear as **Cloudflare One Client**, **Cloudflare WARP**, or **Cloudflare One Agent**, depending on your operating system.

## Connect on Windows

1. Open the **Cloudflare One Client** from the Start menu or select the Cloudflare icon in the system tray.
2. When asked what you want to use the client for, select **Zero Trust security**.
3. Enter the team name provided by IT.
4. A browser window opens. Follow the sign-in method shown:
   - **Microsoft Entra ID (Azure AD):** Select the Microsoft sign-in option and complete the normal work-account sign-in and any MFA prompt. No Cloudflare email PIN is required.
   - **One-time PIN:** Enter your approved work email address and select **Send login code**.
5. For **One-time PIN** only, request the sign-in PIN with **Send login code**, then check your inbox for a message from `noreply@notify.cloudflare.com`.
6. For **One-time PIN** only, enter the code in the browser. The PIN expires after 10 minutes and can be used only once; it is not a permanent PIN that you create or reuse.
7. On the confirmation page, select **Open the Cloudflare One Client**.
8. Confirm the client shows **Connected**. If it does not connect automatically, use the connection switch in the client.

## Connect on macOS

1. Open **Cloudflare One Client**. You can select the Cloudflare icon in the menu bar.
2. Select the gear icon, then go to **Preferences** > **Account**.
3. Select **Login with Cloudflare Zero Trust**.
4. Enter the team name provided by IT.
5. A browser window opens. Follow the sign-in method shown:
   - **Microsoft Entra ID (Azure AD):** Select the Microsoft sign-in option and complete the normal work-account sign-in and any MFA prompt. No Cloudflare email PIN is required.
   - **One-time PIN:** Enter your approved work email address and select **Send login code**.
6. For **One-time PIN** only, request the code, then check your inbox for the PIN from `noreply@notify.cloudflare.com` and enter it in the browser. The PIN expires after 10 minutes and can be used only once.
7. Select **Open Cloudflare WARP.app** when prompted.
8. Confirm the client shows **Connected**.

## Connect on a phone or tablet

1. Install **Cloudflare One Agent** from your device's approved app store.
2. Open the app and select **Next**.
3. Review the privacy policy and select **Accept**.
4. Enter the team name provided by IT.
5. Complete the sign-in steps in your browser. If your organization uses Microsoft Entra ID (Azure AD), sign in with your work account and complete any Microsoft MFA prompt. If IT directs you to use One-time PIN, request the PIN, retrieve it from your email, and enter it before it expires.
6. When prompted, select **Install VPN Profile**, then approve the system connection request.
7. Turn on the connection switch if it is not already connected.

## Confirm you are connected

The Cloudflare One Client should show **Connected**. You can now use the organization's protected resources as instructed by IT.

Do not share your one-time code with anyone. IT will never need the code to complete setup.

## If you cannot connect

| Issue | What to do |
| --- | --- |
| No email code arrives | Check Junk/Spam, wait a few minutes, then request a new code. If it still does not arrive, contact IT. |
| Code is expired or already used | Request a new code. Each code works once, and a new request invalidates the earlier code. |
| You see an access-denied message | Confirm you used the email address approved by IT, then contact IT. |
| The app says the team name is incorrect | Re-enter the team name exactly as provided by IT. Do not use your email domain unless IT specifically gave it as the team name. |
| The client is connected but a work resource will not open | Contact IT and include the resource name, approximate time, and a screenshot of the error. |

## Need help?

Contact IT if you do not have a team name, do not receive a code after checking Spam/Junk, cannot install the client, or receive an access-denied message.

## Cloudflare reference

- [Install and manually enroll the Cloudflare One Client](https://developers.cloudflare.com/cloudflare-one/team-and-resources/devices/cloudflare-one-client/deployment/manual-deployment/)
