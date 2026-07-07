---
title: "Fix Windows Time Sync on Entra ID Joined / Non-Domain Joined Devices"
seo_title: "Fix Windows Time Sync on Entra ID Joined Devices | MSP Technician KB"
description: "Technician KB for diagnosing and fixing Windows Time synchronization on Entra ID joined and non-domain joined Windows devices using remote one-line commands."
keywords: "Windows time sync, Entra ID joined device time sync, w32tm Local CMOS Clock, Windows Time service, non-domain joined Windows, NTP time sync, RMM command prompt, MSP technician KB, IT support Vancouver WA, IT support Portland OR, IT support Seattle WA"
canonical: https://help.svetek.com/docs/Configuration/Azure/fix-windows-time-sync-entra-id/
og_title: "Fix Windows Time Sync on Entra ID Joined Devices"
og_description: "Diagnose Local CMOS Clock, NT5DS, and Windows Time sync failures on Entra ID joined or non-domain joined endpoints."
og_type: article
og_image: https://help.svetek.com/images/logo_horizontal_whitetext.svg
og_url: https://help.svetek.com/docs/Configuration/Azure/fix-windows-time-sync-entra-id/
published_time: 2026-07-07T00:00:00+00:00
date: 2026-07-07
tags:
  - Windows
  - Microsoft Entra
  - Time Sync
  - Technician KB
twitter_title: "Fix Windows Time Sync on Entra ID Joined Devices"
twitter_description: "One-line commands for fixing Windows Time sync on Entra ID joined and non-domain joined Windows endpoints."
twitter_image: https://help.svetek.com/images/logo_horizontal_whitetext.svg
twitter_image_alt: "Svetek logo"
layout: docs
---

Use this KB when a Windows endpoint is **Entra ID joined**, **workgroup joined**, or otherwise **not joined to traditional Active Directory Domain Services**, and Windows Time is not synchronizing correctly.

This article is written for technicians running commands through an **RMM command prompt**, elevated command prompt, or remote command execution tool. Commands are intentionally one-line so they can be pasted into a remote session.

Do not use domain hierarchy time sync for Entra-only or non-domain joined devices. Domain hierarchy sync is for traditional AD domain joined devices that should get time from domain controllers.

## Symptoms

Run this command first:

```cmd
w32tm /query /source
```

Problem output often shows:

```text
Local CMOS Clock
```

Check full status:

```cmd
w32tm /query /status
```

Problem output may include:

```text
Leap Indicator: 3(not synchronized)
Stratum: 0
Last Successful Sync Time: unspecified
Source: Local CMOS Clock
```

Resync may fail with:

```cmd
w32tm /resync
```

Common failure:

```text
The computer did not resync because no time data was available.
```

Configuration may show Windows is trying to use domain hierarchy mode:

```cmd
w32tm /query /configuration
```

Problem output may include:

```text
Type: NT5DS
#Peers: 0
```

`NT5DS` means Windows Time is configured to use the domain hierarchy. That is expected on traditional AD domain joined computers, but it is wrong for Entra ID joined or non-domain joined endpoints because there is no AD domain controller time hierarchy to use.

## Diagnosis

Check the current time source:

```cmd
w32tm /query /source
```

Use this to confirm whether Windows Time is using a real NTP source or falling back to `Local CMOS Clock`.

Check synchronization status:

```cmd
w32tm /query /status
```

Use this to confirm `Leap Indicator`, `Stratum`, `Last Successful Sync Time`, and the active `Source`.

Check Windows Time configuration:

```cmd
w32tm /query /configuration
```

Use this to confirm whether the device is configured for `NTP`, `NT5DS`, or another mode. On Entra ID joined and non-domain joined endpoints, `Type: NT5DS` with `#Peers: 0` usually means the device is pointed at the wrong sync model.

Test whether the endpoint can query a public NTP server:

```cmd
w32tm /stripchart /computer:time.windows.com /samples:5 /dataonly
```

`stripchart` only proves the endpoint can query that NTP server and compare offsets. It does **not** prove the Windows Time service is configured to use that server.

After running `stripchart`, still verify the actual Windows Time source and configuration with:

```cmd
w32tm /query /source
```

```cmd
w32tm /query /status
```

```cmd
w32tm /query /configuration
```

## Fix for Entra ID Joined / Non-Domain Joined Devices

Run this exact one-line command from an elevated local command prompt, RMM command prompt, or remote command execution tool:

```cmd
w32tm /config /manualpeerlist:"time.windows.com,0x8 pool.ntp.org,0x8" /syncfromflags:manual /update && net stop w32time && net start w32time && w32tm /resync /rediscover && w32tm /query /source && w32tm /query /status
```

This command changes Windows Time from domain hierarchy mode to manual NTP mode. It sets `time.windows.com` and `pool.ntp.org` as manual peers, updates the Windows Time configuration, restarts the Windows Time service only after the configuration change, forces rediscovery, and then displays the resulting source and status.

Do not add `/force` to `w32tm /resync`. Some systems reject it with:

```text
The parameter is incorrect. (0x80070057)
```

Use `/rediscover` instead.

## Verify Success

Run this final verification command:

```cmd
w32tm /query /source && w32tm /query /status
```

Expected good signs:

```text
Leap Indicator: 0(no warning)
Last Successful Sync Time: shows a real timestamp
Source: pool.ntp.org,0x8 or time.windows.com
Stratum: is no longer 0
```

Also confirm configuration shows manual NTP mode:

```cmd
w32tm /query /configuration
```

Expected good sign:

```text
Type: NTP
```

The source may show `pool.ntp.org,0x8`, `time.windows.com`, or another valid NTP peer depending on which server Windows selected and how the service reports the active peer.

## Common Confusion

If `w32tm /resync /rediscover` reports:

```text
The computer did not resync because no time data was available.
```

but a later status check shows `Leap Indicator: 0(no warning)`, a real `Last Successful Sync Time`, and a valid NTP source, the device is synced.

The most recent `w32tm /query /status` output is more important than an earlier resync error. Windows Time may update state after rediscovery, service restart, or a later sync attempt.

If `stripchart` shows a small offset, such as under 1 second, the local clock is close to the queried NTP server. That is useful, but technicians still need to confirm Windows Time source and configuration with:

```cmd
w32tm /query /source && w32tm /query /status && w32tm /query /configuration
```

## Do Not Use for Entra-Only Devices

Do not run this command on Entra ID joined or non-domain joined devices:

```cmd
w32tm /config /syncfromflags:domhier /update
```

That command tells Windows to use the domain hierarchy. It is only appropriate for traditional AD domain joined devices that should synchronize time from domain controllers.

For Entra-only or non-domain joined devices, use manual NTP mode instead.

## Traditional AD Domain Joined Devices

For traditional AD domain joined endpoints, the correct design is usually different. Domain members commonly use domain hierarchy time sync so member computers follow domain controllers, and domain controllers follow the organization's authoritative time design.

Do not apply the Entra-only fix blindly to AD domain joined systems unless you are intentionally overriding the domain time design for a specific documented reason.

## When to Escalate

Escalate if:

- UDP 123 is blocked outbound.
- `stripchart` cannot reach public NTP servers.
- The Windows Time service will not start.
- The device repeatedly falls back to `Local CMOS Clock`.
- Time drift returns after reboot.

Repeated drift after reboot may indicate BIOS or UEFI clock problems, CMOS battery issues, virtualization host time issues, or policy management overriding the Windows Time configuration.

## Need Help

For managed Windows endpoint support in Vancouver WA, Portland OR, Seattle WA, and remote environments, Svetek can help standardize Windows Time configuration, identify blocked NTP traffic, and separate Entra-only endpoint remediation from traditional AD domain time design.
