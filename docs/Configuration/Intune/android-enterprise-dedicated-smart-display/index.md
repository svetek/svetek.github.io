---
title: "Configure Android Enterprise Dedicated Smart Displays in Intune"
seo_title: "Manage Android Smart Displays with Intune | Dedicated Device Guide"
description: "Technician procedure for enrolling and managing company-owned Android smart displays as Android Enterprise dedicated devices in Microsoft Intune."
keywords: "Android smart display Intune, Android Enterprise dedicated device, Intune kiosk display, Managed Home Screen, Android digital signage management, Android COSU, Microsoft Intune MSP, IT support Vancouver WA, IT support Portland OR, IT support Seattle WA"
canonical: https://help.svetek.com/docs/Configuration/Intune/android-enterprise-dedicated-smart-display/
og_title: "Configure Android Enterprise Dedicated Smart Displays in Intune"
og_description: "Enroll, lock down, and maintain company-owned Android smart displays as Intune dedicated devices."
og_type: article
og_image: https://help.svetek.com/images/logo_horizontal_whitetext.svg
og_url: https://help.svetek.com/docs/Configuration/Intune/android-enterprise-dedicated-smart-display/
published_time: 2026-08-06T00:00:00+00:00
twitter_title: "Configure Android Enterprise Dedicated Smart Displays in Intune"
twitter_description: "Technician procedure for Intune-managed Android Enterprise smart displays."
twitter_image: https://help.svetek.com/images/logo_horizontal_whitetext.svg
twitter_image_alt: "Svetek logo"
layout: docs
---

Use this procedure to enroll and manage a company-owned Android smart display, digital sign, room display, or other userless Android screen with Microsoft Intune.

This procedure uses **Android Enterprise corporate-owned dedicated devices** (also known as COSU). It is intended for displays that run one approved app or a small approved set of apps. It does not apply to employee phones or personal devices.

For general Android Enterprise tenant setup, see [Roll Out Corporate-Owned Android Enterprise Devices](/docs/Configuration/Intune/android-enterprise-corporate-owned-rollout/).

## Confirm the Device Is Supported

Do this before buying, enrolling, or promising management of a display.

| Requirement | What to verify |
| --- | --- |
| Ownership and use | The display is company-owned and is intended for kiosk, shared, or userless use. |
| Android version | Android 8.0 or later. Use a currently supported version whenever possible. |
| Google services | The exact model and firmware have Google Mobile Services (GMS), can connect to GMS, and are Play Protect certified. |
| Android Enterprise | The manufacturer confirms support for Android Enterprise dedicated-device enrollment. |
| Connectivity | The display can reach the internet during first-run setup through Ethernet, Wi-Fi, or cellular service. |
| Vendor controls | Confirm whether the manufacturer provides OEMConfig for display, power, orientation, firmware, peripheral, and remote-support controls. |

Record the manufacturer, model, SKU, serial number, Android version, security patch level, MAC address, installation location, and display application before enrollment.

> **Stop if the device is only Android-based.** Android-based or AOSP hardware does not automatically support Android Enterprise. If the display does not have GMS and Android Enterprise support, use an AOSP-compatible management design or the manufacturer's management platform instead; do not use this procedure.

## Choose the Enrollment Experience

Use a dedicated-device enrollment profile, not a work profile or a fully managed user-device profile.

| Display use | Enrollment token type |
| --- | --- |
| Shows content or runs an app without a user sign-in | **Corporate-owned dedicated device (default)** |
| Shared display where people sign in and out of supported Microsoft Entra-integrated apps | **Corporate-owned dedicated device with Microsoft Entra ID shared mode** |

Do not use Microsoft Entra shared-device mode merely because the display is shared. It adds Authenticator and a sign-in experience. Use it only when the display application supports shared-device sign-in and sign-out.

## Prepare Intune and Managed Google Play

1. Confirm the tenant's MDM authority is Microsoft Intune and that the tenant is connected to **Managed Google Play**.
2. Confirm the client has appropriate Intune licensing for userless dedicated devices.
3. Create a device group for the display fleet, such as `INTUNE-Android-SmartDisplays-Production`.
4. Create a separate pilot group, such as `INTUNE-Android-SmartDisplays-Pilot`.
5. In Managed Google Play, approve the display application and any required supporting apps.
6. Add the approved apps to Intune and assign them as **Required** to the pilot device group.
7. Record every approved app's display name, package name, owner, version requirement, and support contact.

Dedicated devices only install apps assigned as **Required**. Do not deploy Outlook, Teams, Company Portal, or other user applications unless the display has a documented business requirement for them.

## Create the Dedicated-Device Enrollment Profile

1. Sign in to the [Microsoft Intune admin center](https://intune.microsoft.com/).
2. Go to **Devices** > **Enrollment** > **Android**.
3. Under **Enrollment profiles**, select **Corporate-owned dedicated devices**.
4. Select **Create profile**.
5. Enter a descriptive profile name, such as `Android Smart Display - Production`.
6. Select the token type identified in [Choose the Enrollment Experience](#choose-the-enrollment-experience).
7. Set a token expiration date and document a renewal date before it expires.
8. Enable a device naming template. For example: `SMARTDISPLAY-{{SERIAL}}`.
9. Select the appropriate **device** group for enrollment-time grouping.
10. Apply scope tags when different technicians or clients must be separated.
11. Create the profile and securely store the QR code or token.

Use a separate enrollment profile for each client, environment, or materially different display configuration. Do not rename an active enrollment profile; create a replacement profile instead.

## Configure the Display Experience

Create a device configuration profile for the pilot group before enrolling production devices.

1. Go to **Devices** > **Manage devices** > **Configuration** > **Create**.
2. Select **Android Enterprise** > **Templates** > **Device restrictions**.
3. Name the profile, such as `Android Smart Display - Kiosk Restrictions`.
4. Configure the appropriate kiosk mode and device restrictions below.
5. Assign the profile to the smart-display pilot device group.

### Select the Kiosk Mode

| Display use | Configuration |
| --- | --- |
| One display application only | Set **Kiosk mode** to **Single app** and select the approved app. The app must already be added to Intune and assigned as Required to the device group. |
| Several approved apps, web links, or support controls | Set **Kiosk mode** to **Multi-app**. Deploy and configure Microsoft Managed Home Screen as described in [Configure Multi-App Kiosk with Managed Home Screen](#configure-multi-app-kiosk-with-managed-home-screen). |

Do not allow a browser unless it is needed for the display's documented use. A kiosk policy limits the home experience, but an allowed app can still open other apps or settings if the app supports that behavior. Test every allowed app for breakout paths.

### Set Device Restrictions

Use the following baseline as a starting point. Change a setting only when the display's documented use requires it.

| Setting area | Baseline |
| --- | --- |
| Device settings | Block end-user access to the Settings app. |
| Factory reset | Block reset from device settings. Keep an IT-controlled recovery process. |
| App installation | Block unknown sources and prevent users from adding apps. |
| Power controls | Block the power-button menu in kiosk mode unless onsite staff must restart the display locally. |
| Navigation and status | Keep Home, Overview, status-bar information, and notifications hidden unless the display app requires one of them. |
| Screen capture | Block when the display shows confidential or customer information. |
| USB, Bluetooth, camera, microphone, and location | Block each feature unless it is necessary for the approved display application or attached hardware. |
| Password and lock screen | Configure only what the display model and operating scenario require. A public, userless display should not present an end-user unlock prompt. |
| System updates | Define a supported update behavior and maintenance window before production rollout. |

Configure orientation, brightness, screen timeout, wake-on-power, external displays, and vendor firmware controls through supported Intune settings or the manufacturer's OEMConfig app. These controls vary by model; test them on the exact hardware and firmware deployed.

## Configure Multi-App Kiosk with Managed Home Screen

Skip this section for a true single-app display.

1. Add **Managed Home Screen** from Managed Google Play to Intune.
2. Assign Managed Home Screen as **Required** to the smart-display pilot group.
3. Go to **Apps** > **Configuration** > **Create**.
4. Create a **Managed devices** app configuration policy for Android and select **Managed Home Screen**.
5. Configure only the apps and web links that users need to see.
6. Hide the Managed Settings menu unless an approved onsite support task requires it.
7. If support staff need local identification, allow device information and show the device name; do not expose unnecessary network or settings controls.
8. Configure automatic return to Managed Home Screen after inactivity when the use case requires it.
9. Assign the app configuration policy to the same smart-display device group as the kiosk policy.

Managed Home Screen controls the launcher experience, but it does not replace device restrictions. Keep the device restriction profile assigned so users cannot access Android settings, change network or security configuration, or reset the device.

On Android 14 and later, Managed Home Screen features that automatically relaunch the kiosk or sign out users can require extra Android permissions. Use the manufacturer's OEMConfig only when it can safely grant the required permissions without opening a path to Android Settings. Validate this in the pilot.

## Configure Network and Certificates

The device must have internet access during enrollment and after deployment so Intune can apply policies and Managed Google Play can update apps.

1. Use a secure staging network, Ethernet connection, or approved provisioning Wi-Fi for initial enrollment.
2. Create an **Android Enterprise Wi-Fi** device configuration profile when the display must join a managed wireless network.
3. Assign the Wi-Fi profile to the smart-display pilot group and verify that the device reconnects after restart.
4. For certificate-based Wi-Fi, VPN, or app authentication, deploy the required trusted-root and SCEP or PKCS certificate profiles before the dependent network or app profile.
5. Do not expose Wi-Fi settings in Managed Home Screen for a display that should stay on a fixed network.

Test enterprise Wi-Fi from a factory-reset pilot display. Do not assume that a network can be selected from Managed Home Screen during first-run setup.

## Configure Application, Update, and Security Operations

### Applications

- Assign the display app and all required dependencies as **Required**.
- Test app installation, sign-in or device registration, content synchronization, and restart behavior.
- Keep the application allowlist as small as possible.
- Validate app updates in the pilot group before expanding to production. Managed Google Play apps update automatically when their developer publishes an update.

### Updates

1. Configure Android system-update behavior in the device restrictions profile.
2. Choose a maintenance window that will not interrupt displayed content or business operations.
3. Use a pilot device group before broad OS or firmware updates.
4. Use OEMConfig only when the vendor documents the required firmware or hardware control for the deployed model.
5. Document the display application's supported Android versions and any vendor firmware dependencies.

### Compliance and Access

- Apply a dedicated-device compliance policy that fits the display's risk level, such as minimum OS version, security patch level, root detection, and Play Integrity requirements.
- Assign device restrictions, Wi-Fi, certificates, applications, and compliance policies to device groups, not employee user groups.
- Do not require user-based Conditional Access for a userless display. Design app access around the application's supported device or service authentication method.

## Enroll a Smart Display

1. Confirm the display is factory reset and connected to the approved staging network or Ethernet connection.
2. Start the Android setup wizard.
3. Use the enrollment method selected for the device: QR code, token, zero-touch, Samsung Knox Mobile Enrollment, or another supported manufacturer method.
4. Scan or enter the dedicated-device enrollment token.
5. Do not add a personal Google account.
6. Wait for the Microsoft Intune app, device restrictions, Required apps, and Wi-Fi or certificate profiles to apply.
7. Confirm the device name, ownership, Android Enterprise platform, and enrollment-profile name in Intune.
8. Affix the asset tag and record the installed location before handing off the display.

For a larger deployment, configure Google Zero-touch or the applicable OEM enrollment portal with the exported token JSON. Enroll and validate a pilot display before assigning devices to the production profile.

## Pilot and Acceptance Checklist

Complete every item on one display for each model, firmware version, network type, and display application before broad rollout.

- [ ] Device model meets the requirements in [Confirm the Device Is Supported](#confirm-the-device-is-supported).
- [ ] Device enrolls using the intended dedicated-device profile.
- [ ] Device appears in Intune as corporate-owned Android Enterprise dedicated.
- [ ] Naming template and device-group assignment are correct.
- [ ] Required apps install and the display application launches after restart.
- [ ] Kiosk mode prevents access to unapproved apps and Android settings.
- [ ] Managed Home Screen allowlist and settings behave as intended, when used.
- [ ] Wi-Fi, Ethernet, certificates, and content synchronization work after restart.
- [ ] System-update behavior and the maintenance plan are documented.
- [ ] Onsite support can identify the device and follow the approved recovery process.
- [ ] Factory reset is blocked for end users but IT can recover or replace the device.

## Support and Recovery

Maintain the following record for every display:

- Client, location, room or mounting location, asset tag, serial number, MAC address, and Intune device name.
- Enrollment profile, device group, kiosk mode, applications, Wi-Fi profile, certificates, and OEMConfig profile.
- Display application owner, vendor support contact, token expiration date, and next review date.

If a display stops working:

1. Confirm power, physical connections, and network connectivity.
2. Check the device's last check-in, compliance, profile status, and app-install status in Intune.
3. Confirm that the display application and Managed Home Screen are still assigned as Required.
4. Reboot only if it is permitted by the site's operational process.
5. If recovery requires a factory reset, retire or wipe the device in Intune as appropriate, factory reset it, and enroll it again with the approved dedicated-device profile.
6. Do not reuse an expired or exposed enrollment token. Replace or revoke the token and update zero-touch or OEM portal configuration when necessary.

## References

- [Microsoft: Set up Intune enrollment of Android Enterprise dedicated devices](https://learn.microsoft.com/en-us/intune/device-enrollment/android/setup-dedicated)
- [Microsoft: Android device enrollment guide](https://learn.microsoft.com/en-us/intune/device-enrollment/android/guide)
- [Microsoft: Configure the Microsoft Managed Home Screen app](https://learn.microsoft.com/en-us/intune/app-management/configuration/configure-managed-home-screen)
- [Microsoft: Android device restriction settings](https://learn.microsoft.com/en-us/intune/intune-service/configuration/device-restrictions-android-for-work?tabs=aecorporate)
- [Microsoft: Android Enterprise Wi-Fi settings](https://learn.microsoft.com/en-us/intune/device-configuration/templates/ref-wifi-settings-android-enterprise)
- [Microsoft: Plan Android software updates](https://learn.microsoft.com/en-us/intune/device-updates/android/planning-guide)

## Need Help

Svetek can help organizations in Vancouver WA, Portland OR, and Seattle WA validate Android smart-display hardware, configure Intune dedicated-device kiosk policies, and build a repeatable deployment and support process.
