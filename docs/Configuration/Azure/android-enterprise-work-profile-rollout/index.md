---
title: "Roll Out Android Enterprise Work Profiles in Intune"
seo_title: "Android Enterprise Work Profile Rollout in Intune | MSP Guide"
description: "Rollout guide for setting up Android Enterprise personally owned work profile enrollment in Intune for a new client, including tenant setup, pilot groups, policies, apps, verification, and end-user communication."
keywords: "Android Enterprise work profile, Intune Android enrollment, personally owned work profile, Managed Google Play, Android BYOD, Microsoft Intune rollout, IT support Vancouver WA, IT support Portland OR, IT support Seattle WA"
canonical: https://help.svetek.com/docs/Configuration/Azure/android-enterprise-work-profile-rollout/
og_title: "Roll Out Android Enterprise Work Profiles in Intune"
og_description: "Set up Android Enterprise personally owned work profiles in Intune for a new client rollout."
og_type: article
og_image: https://help.svetek.com/images/logo_horizontal_whitetext.svg
og_url: https://help.svetek.com/docs/Configuration/Azure/android-enterprise-work-profile-rollout/
published_time: 2026-06-29T00:00:00+00:00
twitter_title: "Roll Out Android Enterprise Work Profiles in Intune"
twitter_description: "New-client rollout guide for Android Enterprise personally owned work profile enrollment in Intune."
twitter_image: https://help.svetek.com/images/logo_horizontal_whitetext.svg
twitter_image_alt: "Svetek logo"
layout: docs
---

Use this guide to set up Android Enterprise personally owned devices with a work profile for a **new Intune client**. This is for BYOD Android phones where the company manages work apps and work data, while personal apps and personal data remain outside Intune management.

This guide is adapted for a new-client rollout. Do not configure the **Move to Android Management API** migration policy unless the client already has Intune-managed Android work profile devices that need migration.

For user-facing instructions, send users the [Enroll an Android Phone with a Work Profile](/docs/Guides/Intune/enroll-android-work-profile/) guide.

## Rollout Scope

This rollout covers:

- Android Enterprise personally owned devices with a work profile.
- Web-based enrollment for new Android enrollments.
- Managed Google Play connection and app deployment.
- Baseline compliance and enrollment restrictions.
- Pilot, validation, support, and broad rollout steps.

This rollout does not cover:

- Android device administrator migration.
- Fully managed corporate-owned Android devices.
- Dedicated Android kiosk devices.
- Corporate-owned Android devices with work profile.

## Prerequisites

Before configuration, confirm:

- The client has Microsoft Intune licensing for targeted users.
- Android Enterprise is available in the client's country or region.
- Test users have Android devices that support Android Enterprise and Google Mobile Services.
- The Intune administrator has the **Intune Administrator** role.
- The Microsoft Entra account used for Managed Google Play has an active mailbox.
- Chrome or Microsoft Edge is available on test devices for web-based enrollment.
- Passkeys are not the only accepted authentication method for users who will enroll Android devices.

## Recommended Groups

Create or confirm these Microsoft Entra groups before building policy:

| Group | Purpose |
| --- | --- |
| `INTUNE-Android-WorkProfile-Pilot` | First test users and service desk validation |
| `INTUNE-Android-WorkProfile-Users` | Production users allowed to enroll Android BYOD devices |
| `INTUNE-Android-WorkProfile-Excluded` | Temporary exclusion group for break/fix or exceptions |

Assign policies to the pilot group first. Move users into the production group only after the pilot is complete.

## Connect Managed Google Play

Managed Google Play is required for Android Enterprise management.

1. Sign in to the [Microsoft Intune admin center](https://intune.microsoft.com/).
2. Go to **Devices** > **Enrollment**.
3. Select the **Android** tab.
4. Under **Prerequisites**, open **Managed Google Play**.
5. Accept the data-sharing prompt.
6. Select **Launch Google to connect now**.
7. Follow the Google prompts and create or link the Android Enterprise account.
8. Return to Intune and confirm the connection is active.

Use the client's Microsoft Entra admin account when possible. Avoid using an unmanaged personal Gmail account for a new client setup.

## Enable Web-Based Enrollment

Web-based enrollment is the recommended path for new personally owned Android work profile enrollments.

1. In the Intune admin center, go to **Devices**.
2. Select **Android**.
3. Expand **Device onboarding** and select **Enrollment**.
4. Under **Enrollment Profiles**, select **Personally owned devices with a work profile**.
5. Enable **Use web enrollment for all users enrolling into Android personally owned work profile management**.
6. Save the change.

Treat this as a tenant-wide rollout decision. For a new client, enable it before users begin Android enrollment so the tenant starts clean on the modern enrollment path.

## Configure Enrollment Restrictions

Create enrollment restrictions so users can enroll Android Enterprise work profile devices and so deprecated Android device administrator enrollment is not used.

1. Go to **Devices** > **Enrollment**.
2. Select the **Android** tab.
3. Under **Enrollment options**, open **Device platform restriction**.
4. Select the **Android restrictions** tab.
5. Create a restriction for the pilot group.
6. Configure Android Enterprise personally owned work profile:

| Setting | Recommended value |
| --- | --- |
| Android Enterprise work profile platform | Allow |
| Personally owned work profile | Allow |
| Android device administrator | Block |
| Minimum Android version | Set to client standard, if required |
| Manufacturer restrictions | Leave open unless the client has a known support list |

Assign the restriction to `INTUNE-Android-WorkProfile-Pilot` first. After validation, assign it to `INTUNE-Android-WorkProfile-Users`.

## Configure Compliance Policy

Create a baseline compliance policy for personally owned Android work profile devices.

1. Go to **Devices** > **Compliance policies**.
2. Create a policy for **Android Enterprise**.
3. Select **Personally owned work profile** settings.
4. Configure a practical baseline:

| Category | Recommended baseline |
| --- | --- |
| Rooted devices | Block |
| Play Integrity Verdict | Check basic integrity and device integrity |
| Minimum OS version | Set to the client's support baseline |
| Minimum security patch level | Set if the client requires patch freshness |
| Require encryption | Require, or leave unconfigured because Android Enterprise enforces encryption |
| Password complexity | Use Android 12+ password complexity settings instead of deprecated password type settings |
| Work profile password | Require if the client wants separate work profile protection |

Assign the compliance policy to the pilot group. After successful testing, assign it to the production Android work profile group.

## Configure Conditional Access

Use Conditional Access to require managed and compliant devices for sensitive Microsoft 365 access.

Recommended pilot approach:

1. Create a Conditional Access policy in report-only mode.
2. Target pilot users first.
3. Target cloud apps such as Exchange Online, SharePoint Online, Teams, and Office 365.
4. Require **device to be marked as compliant**.
5. Exclude break-glass accounts and service accounts.
6. Review sign-in logs before switching the policy to **On**.

For BYOD rollouts, communicate that Outlook and Teams may prompt users to enroll before accessing company data.

## Approve and Assign Apps

At minimum, prepare these work apps:

| App | Assignment |
| --- | --- |
| Microsoft Outlook | Required or Available |
| Microsoft Teams | Required or Available |
| Microsoft Edge | Required or Available |
| Microsoft Defender | Required if the client uses Defender for Endpoint |
| Microsoft OneDrive | Available or Required |
| Microsoft Authenticator | Installed automatically during enrollment |
| Microsoft Intune | Installed automatically during web-based enrollment |
| Company Portal | Installed for app browsing and app protection support |

To add apps:

1. Go to **Apps** > **All apps** > **Create**.
2. Select **Managed Google Play app**.
3. Search for the app.
4. Select the app and sync it into Intune.
5. Assign it to the Android pilot group.
6. Set app update mode to **High Priority** for security-critical apps when appropriate.

Only assigned Managed Google Play apps appear for users in the managed Play Store.

## Pilot Rollout

Use a small pilot before enabling broad enrollment.

1. Add 3-5 users to `INTUNE-Android-WorkProfile-Pilot`.
2. Send the [user enrollment guide](/docs/Guides/Intune/enroll-android-work-profile/).
3. Ask users to enroll through one supported entry point:
   - `https://aka.ms/enrollmyandroid`
   - Outlook
   - Teams
4. Confirm the work profile is created.
5. Confirm work apps install in the work profile.
6. Confirm the device appears in Intune as Android Enterprise personally owned work profile.
7. Confirm compliance evaluates correctly.
8. Confirm Conditional Access behavior.
9. Capture any service desk notes before broad rollout.

## Broad Rollout

After pilot validation:

1. Move users into `INTUNE-Android-WorkProfile-Users` in rollout waves.
2. Send user communications 3-5 business days before enforcement.
3. Keep Conditional Access in report-only mode for the first wave if possible.
4. Monitor enrollment failures daily during rollout.
5. Move users with enrollment issues into the exclusion group only when approved.
6. Turn on Conditional Access enforcement after successful pilot and wave validation.

## Verification Checklist

For each pilot and rollout wave, verify:

- Managed Google Play shows connected.
- Web-based enrollment is enabled.
- Android work profile enrollment is allowed.
- Android device administrator enrollment is blocked.
- Required apps are assigned and visible in Intune.
- Test devices show as Android Enterprise personally owned work profile.
- Devices report compliant after policy evaluation.
- Work apps open in the work profile.
- Outlook and Teams can access company data after enrollment.
- Personal apps and personal data are not managed by Intune.

## Common Pitfalls

- Users must enroll from the primary Android user account, not a secondary user profile.
- Chrome or Microsoft Edge should be used for web enrollment.
- If passkeys are the only allowed authentication method, web enrollment may fail.
- Users should skip browser prompts to add the work account to the personal browser and continue enrollment.
- Android 15 Private Space is personal space; Intune does not manage a work profile inside Private Space.
- If Company Portal is old, enrollment may route through the older app-based flow.
- Managed Google Play apps must be assigned before users see them in the managed Play Store.

## Support and Re-Enrollment

If enrollment fails:

1. Confirm the user is licensed for Intune.
2. Confirm the user is in the pilot or production enrollment group.
3. Confirm the device supports Android Enterprise and Google Play Protect.
4. Confirm the user is enrolling from Chrome, Edge, Outlook, Teams, or `https://aka.ms/enrollmyandroid`.
5. If the device partially enrolled, retire the device from Intune before trying again.
6. Have the user remove the work profile from Android settings if the work profile exists but enrollment did not complete.

## References

- [Getting started with Android Enterprise personally owned devices with work profile](https://petervanderwoude.nl/post/getting-started-with-android-enterprise-personally-owned-devices-with-work-profile/)
- [Microsoft: Enroll personal devices with Android Enterprise work profile management](https://learn.microsoft.com/en-us/intune/device-enrollment/android/setup-personal-work-profile)
- [Microsoft: Connect Intune to Managed Google Play](https://learn.microsoft.com/en-us/intune/device-enrollment/android/connect-managed-google-play)
- [Microsoft: Add and assign Managed Google Play apps](https://learn.microsoft.com/en-us/intune/app-management/deployment/add-managed-google-play)
- [Microsoft: Android Enterprise compliance settings](https://learn.microsoft.com/en-us/intune/device-security/compliance/ref-android-enterprise-settings)

## Need Help

Svetek can help organizations in Vancouver WA, Portland OR, and Seattle WA set up Intune Android Enterprise work profile enrollment, Conditional Access, compliance policies, and Microsoft 365 app deployment for BYOD Android users.
