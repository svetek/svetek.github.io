---
title: "Roll Out Corporate-Owned Android Enterprise Devices in Intune"
seo_title: "Corporate-Owned Android Enterprise Rollout in Intune | MSP Guide"
description: "Configuration guide for rolling out corporate-owned Android Enterprise devices in Intune, including fully managed, dedicated, and corporate-owned work profile enrollment options."
keywords: "corporate-owned Android Intune, Android Enterprise fully managed, Android Enterprise dedicated devices, corporate-owned work profile, COPE Android Intune, COBO Android Intune, COSU Android Intune, Managed Google Play, IT support Vancouver WA, IT support Portland OR, IT support Seattle WA"
canonical: https://help.svetek.com/docs/Configuration/Azure/android-enterprise-corporate-owned-rollout/
og_title: "Roll Out Corporate-Owned Android Enterprise Devices in Intune"
og_description: "Configure Intune enrollment for fully managed, dedicated, and corporate-owned Android work profile devices."
og_type: article
og_image: https://help.svetek.com/images/logo_horizontal_whitetext.svg
og_url: https://help.svetek.com/docs/Configuration/Azure/android-enterprise-corporate-owned-rollout/
published_time: 2026-06-29T00:00:00+00:00
twitter_title: "Roll Out Corporate-Owned Android Enterprise Devices in Intune"
twitter_description: "Configure corporate-owned Android Enterprise enrollment options in Intune."
twitter_image: https://help.svetek.com/images/logo_horizontal_whitetext.svg
twitter_image_alt: "Svetek logo"
layout: docs
---

# Roll Out Corporate-Owned Android Enterprise Devices in Intune

Use this guide to configure corporate-owned Android Enterprise enrollment in Microsoft Intune for a new client.

This guide is for company-owned Android devices. For personal Android phones, use the [Android Enterprise work profile rollout guide](/docs/Configuration/Azure/android-enterprise-work-profile-rollout/) and the [Android user enrollment guide](/docs/Guides/Intune/enroll-android-work-profile/).

## Choose the Enrollment Model

| Model | Best for | User association | Personal use | Common examples |
| --- | --- | --- | --- | --- |
| Fully managed | Company-owned, single-user, work-only phones | One assigned user | No | Field staff phones, warehouse phones assigned to one employee |
| Dedicated device | Company-owned shared or kiosk devices | Usually no user, unless shared device mode is used | No | Kiosks, scanners, sign-in tablets, inventory devices |
| Corporate-owned work profile | Company-owned phones that allow personal use | One assigned user | Yes, separated from work data | Executive or staff phones where company owns the device but permits personal use |

Do not use these models for personal BYOD phones.

## Prerequisites

Before creating enrollment profiles, confirm:

- The client has Microsoft Intune licensing for targeted users.
- Android Enterprise is available in the client's country or region.
- Devices support Android Enterprise and Google Mobile Services.
- The Intune tenant is connected to Managed Google Play.
- Required Microsoft Entra groups are created.
- Test devices are factory reset before corporate-owned enrollment.
- Wi-Fi, SIM, or Ethernet connectivity is available during enrollment.

## Recommended Groups

Create groups before building policies and enrollment profiles.

| Group | Purpose |
| --- | --- |
| `INTUNE-Android-Corporate-Pilot` | Pilot users or pilot device operators |
| `INTUNE-Android-FullyManaged-Users` | Users assigned fully managed devices |
| `INTUNE-Android-Dedicated-Devices` | Device group for kiosk or shared-use devices |
| `INTUNE-Android-COPE-Users` | Users assigned corporate-owned work profile devices |
| `INTUNE-Android-Corporate-Excluded` | Temporary exception group |

Use pilot assignments first. Move to production groups after validation.

## Confirm Managed Google Play

Managed Google Play is required for Android Enterprise management.

1. Sign in to the [Microsoft Intune admin center](https://intune.microsoft.com/).
2. Go to **Devices** > **Enrollment**.
3. Select **Android**.
4. Under **Prerequisites**, open **Managed Google Play**.
5. Confirm the tenant is connected.

If it is not connected, complete the Managed Google Play connection before continuing.

## Create a Fully Managed Enrollment Profile

Use fully managed enrollment for company-owned, work-only devices assigned to one user.

1. Go to **Devices** > **Android** > **Android enrollment**.
2. Open **Corporate-owned, fully managed user devices**.
3. Create an enrollment profile.
4. Enter a clear name, such as `Android Fully Managed - Production`.
5. Set an expiration date that matches the rollout plan.
6. Create the profile and generate the enrollment token.
7. Use the generated QR code, token, zero-touch enrollment, Samsung Knox Mobile Enrollment, or another supported provisioning method.

Pilot with a small number of devices before producing a large batch of QR codes or reseller assignments.

## Create a Dedicated Device Enrollment Profile

Use dedicated enrollment for kiosk, shared, userless, or single-purpose Android devices.

1. Go to **Devices** > **Android** > **Android enrollment**.
2. Open **Corporate-owned dedicated devices**.
3. Create an enrollment profile.
4. Choose the token type:
   - **Default** for userless dedicated devices.
   - **Microsoft Entra shared device mode** when supported apps need shared sign-in and sign-out.
5. Name the profile clearly, such as `Android Dedicated - Kiosk`.
6. Create the token.
7. Enroll devices with QR code, token, zero-touch enrollment, Samsung Knox Mobile Enrollment, or another supported provisioning method.

Dedicated devices usually need a device configuration profile or Managed Home Screen policy to lock the device into the intended app experience.

## Create a Corporate-Owned Work Profile Enrollment Profile

Use corporate-owned work profile enrollment when the company owns the phone but allows personal use.

1. Go to **Devices** > **Android** > **Android enrollment**.
2. Open **Corporate-owned devices with work profile**.
3. Create an enrollment profile.
4. Enter a clear name, such as `Android COPE - Production`.
5. Create the profile and generate the enrollment token.
6. Enroll the device from a factory reset state.
7. Have the assigned user sign in during enrollment.

For Android 11 and later, avoid older provisioning methods that are only supported on Android 8-10. Use current provisioning methods such as QR code, zero-touch enrollment, or Samsung Knox Mobile Enrollment.

## Configure Enrollment Restrictions

Use enrollment restrictions to allow the intended corporate-owned Android methods and block legacy Android device administrator enrollment.

Recommended baseline:

| Setting | Recommended value |
| --- | --- |
| Android Enterprise fully managed | Allow |
| Android Enterprise dedicated | Allow if the client uses kiosk or shared devices |
| Android Enterprise corporate-owned work profile | Allow if company-owned personal-use phones are supported |
| Android device administrator | Block |
| Personally owned work profile | Keep separate from corporate-owned policies |
| Minimum Android version | Set to the client support baseline |

Keep corporate-owned and BYOD assignments separate so users do not enroll the wrong device type.

## Configure Compliance Policies

Create separate compliance policies for the corporate-owned model being deployed.

Baseline settings to consider:

| Category | Recommendation |
| --- | --- |
| Rooted devices | Block |
| Play Integrity Verdict | Require basic integrity and device integrity |
| Minimum OS version | Set to client standard |
| Minimum security patch level | Set when patch freshness is required |
| Password or device unlock | Require for user-associated devices |
| Microsoft Defender risk score | Require if Defender for Endpoint is deployed |
| Encryption | Require, or leave unconfigured because Android Enterprise enforces encryption |

For dedicated devices, target compliance policies to device groups where possible.

## Configure Device Restrictions

Create device configuration profiles for the intended use case.

Common corporate-owned settings:

- Block factory reset from device settings when appropriate.
- Require Google Play Protect.
- Control app installation sources.
- Configure system update behavior.
- Configure password or screen lock behavior.
- Disable camera, screen capture, Bluetooth, or USB file transfer if required by policy.
- Configure kiosk or Managed Home Screen behavior for dedicated devices.

Avoid applying the same restrictions to all Android models unless the client accepts the same user experience for fully managed, dedicated, and corporate-owned work profile devices.

## Approve and Assign Apps

At minimum, prepare these apps:

| App | Use case |
| --- | --- |
| Microsoft Intune | Device management app for fully managed and corporate-owned scenarios |
| Microsoft Authenticator | Sign-in and MFA support |
| Company Portal | App browsing and app protection support |
| Microsoft Edge | Managed browser access |
| Microsoft Outlook | Email and calendar |
| Microsoft Teams | Collaboration |
| Microsoft Defender | Required if Defender for Endpoint is part of the baseline |
| Managed Home Screen | Dedicated kiosk or shared device scenarios |

Deploy apps from Managed Google Play where possible. Assign required apps to the relevant user or device groups.

## Pilot Rollout

Pilot each ownership model separately.

1. Enroll one test device per model.
2. Confirm the enrollment profile name and ownership are correct in Intune.
3. Confirm required apps install.
4. Confirm compliance evaluates correctly.
5. Confirm Conditional Access behavior for user-associated devices.
6. Confirm kiosk or shared-device behavior for dedicated devices.
7. Document the provisioning path used for the client.
8. Expand to a small pilot group before broad deployment.

## Verification Checklist

For each model, verify:

- Managed Google Play is connected.
- Enrollment profile exists and has a valid token.
- Device enrolls from factory reset.
- Device ownership shows as corporate.
- Device platform is Android Enterprise.
- Apps install in the expected context.
- Compliance policy applies.
- Device restriction policy applies.
- Conditional Access works for user-associated devices.
- Dedicated devices launch the expected kiosk or shared-device experience.

## Common Pitfalls

- Corporate-owned Android enrollment usually requires a factory reset.
- BYOD work profile instructions should not be used for corporate-owned devices.
- Android device administrator is deprecated for devices with Google Mobile Services and should be blocked.
- Dedicated devices need a kiosk or Managed Home Screen policy after enrollment.
- Corporate-owned work profile devices are different from personally owned work profile devices.
- Zero-touch and Samsung Knox Mobile Enrollment require reseller or portal preparation before devices ship.
- Enrollment tokens expire; refresh them before a large rollout.

## References

- [Microsoft: Android Enterprise enrollment guide](https://learn.microsoft.com/en-us/intune/device-enrollment/android/guide)
- [Microsoft: Set up Android Enterprise fully managed enrollment](https://learn.microsoft.com/en-us/intune/device-enrollment/android/setup-fully-managed)
- [Microsoft: Set up Android Enterprise dedicated device enrollment](https://learn.microsoft.com/en-us/intune/device-enrollment/android/setup-dedicated)
- [Microsoft: Set up Android Enterprise corporate-owned work profile enrollment](https://learn.microsoft.com/en-us/intune/device-enrollment/android/setup-corporate-work-profile)
- [Microsoft: Connect Intune to Managed Google Play](https://learn.microsoft.com/en-us/intune/device-enrollment/android/connect-managed-google-play)
- [Microsoft: Add and assign Managed Google Play apps](https://learn.microsoft.com/en-us/intune/app-management/deployment/add-managed-google-play)

## Need Help

Svetek can help organizations in Vancouver WA, Portland OR, and Seattle WA design and deploy corporate-owned Android Enterprise enrollment with Intune, including fully managed phones, dedicated kiosk devices, shared devices, and corporate-owned work profile devices.
