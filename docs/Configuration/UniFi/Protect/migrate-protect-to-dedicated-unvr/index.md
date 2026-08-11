---
title: "Migrate UniFi Protect to a Dedicated UNVR"
seo_title: "Migrate UniFi Protect to a Dedicated UNVR | Configuration Runbook"
description: "Technician procedure for moving UniFi Protect cameras and configuration from an existing UniFi console to a dedicated UNVR while leaving UniFi Network on the original console."
keywords: "migrate UniFi Protect to UNVR, UniFi Protect UNVR migration, move cameras to UNVR, dedicated UniFi Protect console, UNVR configuration, UniFi Protect backup restore, MSP UniFi Protect runbook, IT support Vancouver WA, IT support Portland OR, IT support Seattle WA"
canonical: https://help.svetek.com/docs/Configuration/UniFi/Protect/migrate-protect-to-dedicated-unvr/
og_title: "Migrate UniFi Protect to a Dedicated UNVR"
og_description: "Move UniFi Protect from an existing console to a dedicated UNVR without moving UniFi Network."
og_type: article
og_image: https://help.svetek.com/images/logo_horizontal_whitetext.svg
og_url: https://help.svetek.com/docs/Configuration/UniFi/Protect/migrate-protect-to-dedicated-unvr/
published_time: 2026-08-10T00:00:00+00:00
twitter_title: "Migrate UniFi Protect to a Dedicated UNVR"
twitter_description: "Technician runbook for migrating UniFi Protect cameras and settings to a dedicated UNVR."
twitter_image: https://help.svetek.com/images/logo_horizontal_whitetext.svg
twitter_image_alt: "Svetek logo"
layout: docs
---

Use this runbook to move UniFi Protect cameras and Protect configuration from an existing UniFi console, such as a Cloud Gateway or CloudKey+, to a dedicated UniFi Network Video Recorder (UNVR).

This is a **configuration migration**, not a troubleshooting procedure. The objective is to offload recording and camera management to the UNVR while leaving UniFi Network on the existing Network console.

## Target Topology

| Before | After |
| --- | --- |
| One console runs **UniFi Network** and **UniFi Protect**. | The existing Cloud Gateway or Network Server continues to run **UniFi Network**. |
| Cameras record to the existing console. | The dedicated **UNVR** runs **UniFi Protect** and records the cameras. |

Ubiquiti supports dedicated UNVR-series consoles for Protect deployments alongside a separate UniFi Network console. Do not migrate the Network application or network-device management to the UNVR; UNVR-series devices are primarily for Protect and Access.

## Important Limitations

- **Existing recordings do not migrate** to the UNVR. Export clips that the client must retain before the cutover.
- If existing Protect drives are moved into the UNVR, they must be reformatted. Reformatting erases the recordings on those drives.
- Plan a short camera-recording interruption during cutover.
- Do not factory reset, remove, or reformat the original console's Protect storage until the client has approved the retention and disposal of historical recordings.
- The UNVR and cameras should be on the same VLAN during migration. Confirm routing and firewall rules before cutover if the final design uses different networks.

## Prerequisites

Before scheduling the change, confirm:

- An authorized console Owner can access the original console and its **Settings > Control Plane > Backups** page.
- The UNVR is installed, online, updated, and has supported storage installed for the required retention and camera count.
- The UNVR is connected to the same camera-management VLAN for migration.
- The original console and UNVR are on compatible, current UniFi OS and Protect releases. When restoring to a different console model, the new device must run UniFi OS 3.1 or later.
- The client has approved the maintenance window, retention decision, and expected recording interruption.
- A current inventory exists for cameras, sensors, third-party cameras, Protect users, alerts, integrations, storage settings, and exported clips.
- The Network console and its gateway, switch, VLAN, and Wi-Fi configuration will remain in place.

## Plan Storage and Recording Retention

1. Review the original Protect retention period and identify recordings the client must keep.
2. Export the required clips before beginning the migration.
3. Decide whether the original console and its drives will be retained for read-only historical playback, repurposed, or disposed of after the retention period.
4. Install storage in the UNVR according to the retention target and Ubiquiti compatibility guidance.
5. If reusing drives from the original Protect console, obtain written approval to erase their recordings before installing them in the UNVR.

Do not represent a configuration backup as a video-recording backup. The backup moves Protect settings and device management, not stored video.

## Prepare the UNVR

1. Rack or mount the UNVR, install the approved drives, and connect power and network.
2. Complete UniFi OS setup and apply the approved updates before the maintenance window.
3. Confirm that the UNVR is visible in [UniFi Site Manager](https://unifi.ui.com/) and that the Protect application can be opened.
4. Confirm the UNVR has an IP address and can reach the camera-management VLAN.
5. Do not manually adopt the cameras to the UNVR before restoring the backup.
6. Document the UNVR's model, serial number, IP address, drive configuration, RAID or storage status, and Protect version in the change ticket.

## Create and Verify the Backup

1. On the original console, sign in as the Owner.
2. Go to **Settings > Control Plane > Backups**.
3. Select **Back Up Now** and wait for the backup to complete.
4. Confirm the backup time is immediately before the planned migration.
5. Download an offline copy if the client requires one under its backup policy.
6. If Protect administrators must move with the migration, use a cloud backup and include the required administration settings during restore.

Do not continue with an old, incomplete, or unverified backup.

## Migrate Protect to the UNVR

Perform these steps during the approved maintenance window.

1. On the original console, complete one final check that all cameras are online and recording.
2. Go to **Settings > Control Plane**, select the **Protect** application, and select **Stop**.
3. On the UNVR, open **Settings > Control Plane > Backups**.
4. Select **Restore** and choose the verified backup from the original console.
5. When restoring to the different UNVR model, clear **Restore All Applications and Settings** and select the Protect settings required for the migration. Do not select UniFi Network settings.
6. Include administration settings only when they are needed and supported by the chosen backup method.
7. Start the restore and wait for the UNVR to complete setup and apply the Protect configuration.
8. Confirm the cameras appear in Protect on the UNVR and begin recording.

After restoration, the cameras can appear as **adopted but offline** on the original console. This is expected while historical recordings remain accessible there and the cameras record new footage on the UNVR.

## Validate the Cutover

Complete and document each check before closing the change.

- [ ] UniFi Network remains online and continues to manage gateways, switches, and access points on the existing Network console.
- [ ] The UNVR opens UniFi Protect and reports healthy storage.
- [ ] Every camera, sensor, and third-party camera appears in the UNVR Protect inventory.
- [ ] Each camera has live video, a current timestamp, and a new recording after the cutover.
- [ ] Camera names, locations, recording modes, detections, notifications, users, and integrations match the approved migration scope.
- [ ] Remote Protect access and mobile-app access work for authorized users.
- [ ] The client confirms that historical recordings remain available on the original console, when retention requires it.
- [ ] The original console's Protect application remains stopped after the UNVR becomes the active recording host.

## Non-Network Console Auto-Recovery Notice

After the UNVR is installed as the dedicated Protect console, the interface can show a notice similar to:

> **This device is managed by a non-Network UniFi Console**

with a statement that **Device Auto-Recovery** is available in a future update.

In this migration topology, the UNVR intentionally hosts Protect while another console hosts UniFi Network. Treat this message as a current Device Auto-Recovery feature limitation, not as a failed migration, when Protect is functioning and cameras are recording normally.

Record the notice in the change ticket and review UniFi OS, Protect, and Network release notes during normal maintenance. Do not move Protect back to the Network console solely to remove the message.

## Rollback and Recovery

Use the original console only as the rollback option during the approved change window.

1. If the UNVR restore fails or cameras do not begin recording, stop the migration and preserve the original console and its storage.
2. Do not reformat original Protect drives or factory reset the original console.
3. Restart Protect on the original console only after confirming that the UNVR will not remain the active recording host.
4. Document the failure, backup time, camera status, and the point at which the migration stopped.
5. Escalate to Ubiquiti support when the verified backup cannot be restored or supported cameras fail to migrate.

## Post-Migration Operations

- Update client documentation with the UNVR as the Protect host and the original console as the Network host.
- Update monitoring, warranty, storage-health, backup, and firmware-maintenance records for both consoles.
- Set the retention and disposal date for the original console's recordings.
- Confirm that technicians use the UNVR Protect application for future camera management and the original Network console for network management.
- Keep the original console powered and accessible only as long as the client-approved recording-retention plan requires it.

## Related Resources

- [Ubiquiti: Migrating Cameras Between NVRs](https://help.ui.com/hc/en-us/articles/19118654419607-Migrating-Cameras-Between-NVRs)
- [Ubiquiti: Backups and Migration in UniFi](https://help.ui.com/hc/en-us/articles/360008976393-Backups-and-Migration-in-UniFi)
- [Ubiquiti: Choosing the Right UniFi Control Plane](https://help.ui.com/hc/en-us/articles/30127033090071-Choosing-the-Right-UniFi-Control-Plane)
- [Ubiquiti: UniFi Storage Requirements and Compatibility](https://help.ui.com/hc/en-us/articles/360037340954-UniFi-Storage-Requirements-and-Compatibility)

## Need Help

Svetek supports UniFi Protect migrations and UNVR deployments for organizations in Vancouver WA, Portland OR, and Seattle WA. Include the source console, target UNVR, camera count, storage plan, backup time, maintenance window, and recording-retention decision in the change request.
