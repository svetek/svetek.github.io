---
title: "Add a User to a Shared Mac with Platform SSO"
seo_title: "Add a User to a Shared Mac with Platform SSO | Intune macOS Guide"
description: "Step-by-step guide for adding a user to an Intune-managed shared Mac with Platform SSO enabled by pre-staging a local macOS account."
keywords: "Intune shared Mac, macOS Platform SSO, Entra ID Platform SSO, pre-stage local account, macOS user provisioning, shared Mac login, IT support Vancouver WA, IT support Portland OR, IT support Seattle WA"
canonical: https://help.svetek.com/docs/Guides/Intune/add-user-shared-mac-platform-sso/
og_title: "Add a User to a Shared Mac with Platform SSO"
og_description: "Pre-stage a local macOS account, complete first login, and register Platform SSO for an Intune-managed shared Mac."
og_type: article
og_image: https://help.svetek.com/images/logo_horizontal_whitetext.svg
og_url: https://help.svetek.com/docs/Guides/Intune/add-user-shared-mac-platform-sso/
published_time: 2026-06-26T00:00:00+00:00
twitter_title: "Add a User to a Shared Mac with Platform SSO"
twitter_description: "Pre-stage a local account and register Platform SSO for an Intune-managed shared Mac."
twitter_image: https://help.svetek.com/images/logo_horizontal_whitetext.svg
twitter_image_alt: "Svetek logo"
layout: docs
---

# Add a User to a Shared Mac with Platform SSO

Use the **pre-stage local account** method for Intune-managed shared Macs where Platform SSO is enabled.

This guide is for Macs where login-window Entra provisioning is not working reliably. In that scenario, pre-staging the local macOS account first is the practical path. Each local user still needs to complete their own Platform SSO registration after reaching the desktop.

## Prerequisites

- Confirm the Mac is enrolled in Intune and has the Platform SSO configuration profile assigned.
- Confirm you have a working local administrator account on the Mac.
- Replace the example username, full name, temporary password, and Entra ID email address with the real user's details.
- Use a temporary password that meets the organization's local macOS password requirements.

## Add Another User Locally

Log in as the local administrator and run:

```bash
sudo sysadminctl -addUser john -fullName "John Doe" -password 'Password123!'
sudo pwpolicy -u john -setpolicy "newPasswordRequired=1"
```

The `sysadminctl` command above creates a standard local user. Do not add the `-admin` option unless the user should be a local administrator.

## Verify the Local Account

Verify the account:

```bash
id john
dscl . -read /Users/john NFSHomeDirectory
```

Expected home directory:

```text
NFSHomeDirectory: /Users/john
```

Give the user the temporary Mac login details through an approved secure channel.

## User First Login {#user-first-login}

At the Mac login screen, sign in with the temporary local Mac account:

```text
Username: john
Password: Password123!
```

macOS should prompt you to set a new **local Mac password**.

After you reach the desktop, look for the Platform SSO registration prompt.

If the registration prompt does not appear:

1. Open **System Settings**.
2. Go to **Users & Groups**.
3. Open **Network Account Server**.
4. Click **Register**.
5. Sign in with your Entra account, for example:

```text
john@company.com
```

## Enable or Register Platform SSO

Platform SSO registration connects the local Mac account to the user's Entra account. Registration is per user, so every local user on the shared Mac must complete this step.

If the user has already reached the desktop but is not registered:

1. Open **System Settings**.
2. Go to **Users & Groups**.
3. Open **Network Account Server**.
4. Click **Register**.
5. Have the user sign in with their Entra account.

## Common Pitfalls

- The local username must match the account created with `sysadminctl`; in this example, the username is `john`.
- The temporary password is only for the local Mac account. The user still signs in with their Entra account during Platform SSO registration.
- Platform SSO registration is per local user. Registering one user does not register every account on the shared Mac.
- If the Platform SSO registration button is missing, confirm the Mac has received the Intune Platform SSO configuration profile.

## Notes

Apple's Platform SSO flow supports shared Macs with shared device keys and create-user-at-login. When login-window Entra provisioning is not working, pre-staging local accounts avoids relying on that provisioning path while still allowing each user to register Platform SSO after first login.

Reference: [Apple Platform SSO for macOS](https://support.apple.com/guide/deployment/platform-sso-for-macos-dep7bbb05313/web)

## Need Help

Svetek can help organizations in Vancouver WA, Portland OR, and Seattle WA configure Intune-managed Macs, Platform SSO, and shared-device user workflows.
