---
title: "UniFi NVR Non-Network Console Auto-Recovery Notice"
seo_title: "UniFi NVR Non-Network Console Auto-Recovery Notice | Troubleshooting"
description: "Technician guidance for the UniFi notice that a UNVR or Protect console is managed by a non-Network UniFi Console and does not yet support Device Auto-Recovery."
keywords: "UniFi NVR non-Network console, UniFi Protect Device Auto-Recovery, UNVR Auto-Recovery notice, UniFi Protect warning, UniFi NVR troubleshooting, MSP UniFi Protect support, IT support Vancouver WA, IT support Portland OR, IT support Seattle WA"
canonical: https://help.svetek.com/docs/Configuration/UniFi/Protect/non-network-console-auto-recovery-notice/
og_title: "UniFi NVR Non-Network Console Auto-Recovery Notice"
og_description: "Understand the expected Device Auto-Recovery limitation shown for a UniFi Protect NVR that is not a UniFi Network console."
og_type: article
og_image: https://help.svetek.com/images/logo_horizontal_whitetext.svg
og_url: https://help.svetek.com/docs/Configuration/UniFi/Protect/non-network-console-auto-recovery-notice/
published_time: 2026-08-10T00:00:00+00:00
twitter_title: "UniFi NVR Non-Network Console Auto-Recovery Notice"
twitter_description: "Technician guidance for an expected UniFi Protect Auto-Recovery availability notice."
twitter_image: https://help.svetek.com/images/logo_horizontal_whitetext.svg
twitter_image_alt: "Svetek logo"
layout: docs
---

Use this article when a newly installed UniFi Network Video Recorder (UNVR) shows the message:

> **This device is managed by a non-Network UniFi Console**

and indicates that **Device Auto-Recovery** will be available in a future update.

## Summary

This is normally a feature-availability notice, not an installation failure.

A UNVR is commonly deployed as a dedicated UniFi Protect console for camera recording and management. In this topology, UniFi Network runs on a separate Cloud Gateway, CloudKey, or Network Server. Ubiquiti supports using dedicated consoles to offload UniFi Protect while a separate console manages the network.

The notice means the displayed device does not currently support the indicated **Device Auto-Recovery** function when it is associated with a console that does not run UniFi Network. It does not mean that the UNVR, Protect, or the camera installation is misconfigured.

## Expected Behavior

When this notice is the only symptom:

- UniFi Protect recording, playback, and camera management should continue to work normally.
- Keep the UNVR deployed as the UniFi Protect console.
- Do not move the UNVR to the Network console or reinstall it solely to remove this notice.
- Treat Device Auto-Recovery as unavailable for this console topology until Ubiquiti adds support.
- Review future UniFi OS, Protect, and Network release notes before changing the deployment design.

The phrase **available in a future update** describes Ubiquiti's current feature limitation. It does not provide a release date or require an immediate configuration change.

## Why the Notice Appears

UniFi functions are provided by individual applications running on UniFi consoles. A Network console manages UniFi Network devices and configuration. A UNVR is typically dedicated to Protect and can be deployed alongside that Network console for video storage and camera management.

Some supervision and recovery capabilities depend on the Network application being available to the console associated with the device. When the associated console is a Protect-only or otherwise non-Network console, the interface can show this notice instead of enabling Device Auto-Recovery.

## Technician Response

1. Confirm that the UNVR is online and that the **Protect** application opens.
2. In Protect, confirm that the cameras are adopted, online, recording, and viewable.
3. Confirm that UniFi Network is intentionally hosted on a separate Cloud Gateway, CloudKey, or Network Server.
4. Record the exact notice, console model, UniFi OS version, Protect version, Network host, and affected device in the service ticket.
5. Explain that the notice affects Device Auto-Recovery availability only; it is not evidence of a failed NVR installation.
6. Leave the approved console topology unchanged unless the client has a separate requirement to change management architecture.

## Do Not Treat This as a Device Fault

| Symptom | Technician action |
| --- | --- |
| The notice appears, but cameras are online and recording | No remediation is required. Document the limitation and monitor future updates. |
| A camera is offline, will not adopt, or is not recording | Troubleshoot the camera, PoE, VLAN, connectivity, and Protect adoption separately. Do not attribute the fault to this notice. |
| A device says **Managed by Other** or **Managed by Another Console** | This is a separate adoption issue. Verify the original managing application, then restore, unmanage, or re-adopt the device as appropriate. |
| The UNVR or Protect application is unavailable | Treat this as a console or Protect service issue. Check power, storage, network connectivity, application status, and backups. |

## When to Escalate

Escalate to Ubiquiti support or the client-approved escalation path when:

- The wording is different from the notice documented here.
- Camera recording, playback, adoption, or remote access is not working.
- The device requires a recovery action that cannot be completed from its current console.
- A current Ubiquiti release indicates the feature should be supported, but the notice remains after all relevant applications and firmware are updated.

Include a screenshot of the notice, the exact device and console models, application versions, device firmware versions, topology, and the affected device's status.

## Related Resources

- [Ubiquiti: Choosing the Right UniFi Control Plane](https://help.ui.com/hc/en-us/articles/30127033090071-Choosing-the-Right-UniFi-Control-Plane)
- [Ubiquiti: Running Multiple UniFi Network Consoles on the Same Site](https://help.ui.com/hc/en-us/articles/29946579238679-Running-Multiple-UniFi-Network-Consoles-on-the-Same-Site)
- [Ubiquiti: Getting Started with UniFi Protect](https://help.ui.com/hc/en-us/articles/27878858632599-Getting-Started-with-UniFi-Protect)
- [Ubiquiti: Troubleshooting UniFi Device Connectivity](https://help.ui.com/hc/en-us/articles/7258465146519-Troubleshooting-UniFi-Device-Connectivity)

## Need Help

Svetek supports UniFi Protect and UNVR deployments for organizations in Vancouver WA, Portland OR, and Seattle WA. Include the console type, camera or device, screenshot, application versions, and recording status when requesting support.
