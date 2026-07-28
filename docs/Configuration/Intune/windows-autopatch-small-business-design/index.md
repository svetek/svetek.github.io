---
title: "Windows Autopatch Design for Small Business Tenants"
seo_title: "Windows Autopatch Design for Intune Small Business Tenants | MSP Guide"
description: "Design Windows Autopatch for Intune-managed small business tenants, including Autopatch groups, deployment rings, naming conventions, cadence settings, operations, and per-tenant documentation."
keywords: "Windows Autopatch Intune, Windows Autopatch small business, Intune update rings, Autopatch groups, Microsoft 365 Business Premium Autopatch, Intune patch management, MSP Intune guide, IT support Vancouver WA, IT support Portland OR, IT support Seattle WA"
canonical: https://help.svetek.com/docs/Configuration/Intune/windows-autopatch-small-business-design/
og_title: "Windows Autopatch Design for Small Business Tenants"
og_description: "A practical MSP design guide for Windows Autopatch in Intune-managed small business tenants up to 300 devices."
og_type: article
og_image: https://help.svetek.com/images/logo_horizontal_whitetext.svg
og_url: https://help.svetek.com/docs/Configuration/Intune/windows-autopatch-small-business-design/
published_time: 2026-07-28T00:00:00+00:00
date: 2026-07-28
tags:
  - Microsoft Intune
  - Windows Autopatch
  - Endpoint Management
  - MSP Operations
twitter_title: "Windows Autopatch Design for Intune SMB Tenants"
twitter_description: "Design Autopatch groups, rings, cadence, operations, and recordkeeping for Intune-managed SMB tenants."
twitter_image: https://help.svetek.com/images/logo_horizontal_whitetext.svg
twitter_image_alt: "Svetek logo"
layout: docs
---

Use this guide to design a repeatable Windows Autopatch model for Intune-managed small business tenants with up to 300 Windows 10/11 client devices. It standardizes Autopatch groups, deployment rings, naming conventions, cadence settings, operational review, and per-tenant documentation.

Applies to: Intune-managed Windows 10/11 client devices in customer tenants of 1 to 300 devices.

## Purpose

Standard, repeatable Windows Autopatch design for SMB tenants, scaled by fleet size, using Svetek naming conventions and coexisting cleanly with the ConditionalAccessBaseline (j0eyv) import.

Deliverables per tenant: one or more Autopatch groups, a documented ring model, named Entra device groups, and a filled-in record sheet (Section 10).


## Prerequisites and boundaries

| Item | Requirement |
| --- | --- |
| Licensing | Autopatch is included with Microsoft 365 Business Premium, Windows 10/11 Enterprise E3/E5 (M365 F3/E3/E5), and Windows 10/11 Education A3/A5. Business Premium is the normal SMB case. |
| Support tickets | Autopatch support requests require E3+/F3. Business Premium tenants cannot open Autopatch support cases, so Svetek is the escalation path. Plan rollback locally. |
| Device SKU | Client only: Enterprise, Pro, Pro for Workstations, Education, Pro Education. Corporate-owned, Intune-managed (or co-managed with Windows Update and Device configuration workloads pointed at Intune). |
| Servers | Not in scope. Windows Server is not registered with Autopatch. |
| Entra groups | Device-based only. User-based groups are not supported by Autopatch groups. |
| Tenant prereq | App-only auth must be on in the Autopatch tenant, or Autopatch groups behaves unpredictably. |
| Stale objects | Clean up stale/duplicate Entra device records before creating the Autopatch group, or devices land in "Not registered / Prerequisites failed". |
| Registration lag | Up to 48 hours for a new tenant's devices to show as Registered. Device discovery runs hourly after that. |
| Check-in windows | Device must have contacted Intune within 28 days (Autopatch readiness) and within 5 days (Microsoft 365 Apps eligibility). |
| M365 Apps | Every Autopatch-registered device receives Microsoft 365 Apps updates from Monthly Enterprise Channel. If the tenant is on Current Channel today, expect the channel change and communicate it. Teams updates on its own channel. |

Hard limits worth knowing: 300 Autopatch groups per tenant, 15 deployment rings per Autopatch group. Neither is a constraint at SMB scale.


## Naming convention

### 3.1 Existing conventions in play

Svetek Intune objects: `MSP-<PLATFORM>-<TYPE>-<SCOPE>-<Descriptor>`
Examples already in the tenant: `MSP-IOS-CFG-CORP-SSO-Extension`, `MSP-MAC-CFG-ALL-DefenderAccessibility`, `MSP-IPAD-ADE-CORP-SHARED-CONFIG`.

ConditionalAccessBaseline objects: `CA<nnn>-<Persona>-<PolicyType>-<App>-<Platform>-<GrantControl>[-<Descriptor>]`, with exclusion groups in the form `CA - <Descriptor> - Exclude` (for example the break-glass exclusion group created by the import). The `CA` prefix and the `MSP` prefix never collide, so both schemes coexist without changes.

Older imported policies with no prefix (`Default AV Policy`, `LAPS`, `ASR Default rules`, `CIPP: ...`) are left alone. Do not rename them as part of an Autopatch build.

### 3.2 New type codes for Autopatch work

| Code | Meaning |
| --- | --- |
| `DEV` | Entra device security group that Svetek creates and controls |
| `APG` | Autopatch group (the container created in Tenant administration) |
| `UPD` | Hand-built Windows update policy created outside Autopatch (hotpatch policy, exceptions) |

### 3.3 Device groups (test and prod)

Pattern: `MSP-WIN-DEV-<RING>-<QUALIFIER>`

| Group name | Membership | Role |
| --- | --- | --- |
| `MSP-WIN-DEV-POOL-CORP` | Dynamic: Windows + corporate-owned | Distribution pool only. Never assigned directly to a ring. |
| `MSP-WIN-DEV-RING0-TEST` | Assigned, manual | Test ring. IT device plus 1 or 2 volunteer users. |
| `MSP-WIN-DEV-RING1-PILOT` | Assigned (small tenants) or dynamic share of pool (100+) | Early adopters, one per department where possible. |
| `MSP-WIN-DEV-RING2-PROD` | Dynamic share of pool, or assigned | General production fleet. |
| `MSP-WIN-DEV-RING3-PRODB` | Dynamic share of pool | Second production wave. Only used at 100+ devices. |
| `MSP-WIN-DEV-RING9-LAST` | Assigned, manual | Reboot-sensitive and business-critical endpoints: front desk, POS, scheduling station, principal's laptop. |
| `MSP-WIN-DEV-EXCL-AUTOPATCH` | Assigned, manual | Devices deliberately outside Autopatch. Never assigned to any ring. Document the reason per device. |

Why the digits: `RING0`, `RING1`, `RING2`, `RING3`, `RING9` sort in the Entra and Intune portals in the same order as the rollout, which makes membership mistakes visible at a glance. `RING9-LAST` is deliberately left as the highest number so extra middle rings can be inserted later without renumbering.

Suggested dynamic rule for the pool group (adjust to the tenant):

```
(device.deviceOSType -eq "Windows") and (device.deviceOwnership -eq "Company") and (device.managementType -eq "MDM")
```

### 3.4 Autopatch groups

Pattern: `MSP-WIN-APG-<SCOPE>`

| Name | Use |
| --- | --- |
| `MSP-WIN-APG-CORP` | Default for the tenant. Information worker release schedule. |
| `MSP-WIN-APG-SHARED` | Shared or multi-user devices, if the tenant has them. |
| `MSP-WIN-APG-KIOSK` | Kiosk, signage, or always-on devices. |
| `MSP-WIN-APG-SITE-<CITY>` | Only when a second site needs its own maintenance window. |

Keep the name at 64 characters or fewer. Microsoft documentation currently states 255 characters in one place and 64 in another, and the name is appended to every policy and service-created group name, so short names stay readable in reports either way.

The release schedule preset cannot be changed after an Autopatch group is created. That is the main reason to split kiosk and shared-device fleets into their own Autopatch group rather than a separate ring.

### 3.5 Service-created objects: do not touch

Autopatch creates its own Entra device groups and Intune policies, named after the Autopatch group and ring, for example `Windows Autopatch Microsoft 365 Update Policy - <group name> - <ring name>`. Rules:

- Do not rename, delete, or hand-edit them.
- Do not change their membership type (Assigned versus Dynamic). Doing so breaks the service's ability to read membership.
- Do not sync Configuration Manager collections into them.
- Renaming the Autopatch group cascades the new name into all associated update ring, feature update, and ring group names. Rename once, early, or not at all.

### 3.6 Hand-built policies

Pattern: `MSP-WIN-UPD-<SCOPE>-<Descriptor>`
Example: `MSP-WIN-UPD-CORP-Hotpatch-Allow`, `MSP-WIN-UPD-EXCL-NoHotpatch-Arm64`.


## Ring models by fleet size

The 100-device line is not arbitrary. Microsoft documents that below 100 devices in an Autopatch group, dynamic percentage distribution may not match the percentages you set. Below that count, control membership with assigned groups instead of percentages.

### Tier 1: 1 to 30 devices

Three rings, all assigned membership. No percentage distribution.

| Ring | Source group | Typical size |
| --- | --- | --- |
| Test | `MSP-WIN-DEV-RING0-TEST` | 1 to 3 |
| Ring1 | `MSP-WIN-DEV-RING2-PROD` (assigned) | remainder |
| Last | `MSP-WIN-DEV-RING9-LAST` | 1 to 4 critical devices |

Notes: at this size, one Autopatch group (`MSP-WIN-APG-CORP`). If the tenant has fewer than 5 devices total, Test plus Last is acceptable, but tell the customer in writing that a two-ring model means very little validation time.

### Tier 2: 31 to 100 devices

Four rings. Still assigned membership for Test and Last; Pilot can be assigned (preferred at this size, so you can pick one device per department) with the remainder distributed dynamically.

| Ring | Source | Target share |
| --- | --- | --- |
| Test | `MSP-WIN-DEV-RING0-TEST`, assigned | 2 to 4 devices |
| Ring1 (Pilot) | `MSP-WIN-DEV-RING1-PILOT`, assigned | roughly 10 to 15 percent |
| Ring2 (Prod) | `MSP-WIN-DEV-POOL-CORP`, dynamic 100 percent | remainder |
| Last | `MSP-WIN-DEV-RING9-LAST`, assigned | critical devices |

### Tier 3: 101 to 300 devices

Five rings. Percentages are now reliable, so use dynamic distribution for the middle rings.

| Ring | Source | Target share |
| --- | --- | --- |
| Test | `MSP-WIN-DEV-RING0-TEST`, assigned | 3 to 5 devices |
| Ring1 (Pilot) | `MSP-WIN-DEV-POOL-CORP`, dynamic | 5 percent |
| Ring2 (Prod A) | `MSP-WIN-DEV-POOL-CORP`, dynamic | 35 percent |
| Ring3 (Prod B) | `MSP-WIN-DEV-POOL-CORP`, dynamic | 60 percent |
| Last | `MSP-WIN-DEV-RING9-LAST`, assigned | critical devices |

Dynamic percentages must total exactly 100 across the dynamically distributed rings.

### Ring precedence, which is what makes this work

Within one Autopatch group, an Assigned ring wins over a Dynamic ring for the same device. So the pool group can safely include the Test and Last devices: their assigned ring placement takes precedence. If a device is assigned to two rings of the same type, the later ring in the order wins, which is why no device should ever be a member of both `RING0-TEST` and `RING9-LAST`.

Across different Autopatch groups there is no automatic resolution. The device shows as Not ready and you must pick its group manually. Also, a given Entra device group can only be assigned to one deployment ring at a time across the entire tenant.


## Cadence and workload settings

Svetek defaults. Record actual values per tenant, since the preset supplies the starting numbers and these are our adjustments to it.

| Ring | Quality deferral | Deadline | Grace period | Feature update deferral |
| --- | --- | --- | --- | --- |
| Test | 0 days | 2 days | 1 day | 0 days |
| Pilot | 1 day | 2 days | 2 days | 7 days |
| Prod / Prod A | 3 days | 3 days | 2 days | 14 days |
| Prod B | 4 days | 3 days | 2 days | 21 days |
| Last | 6 days | 4 days | 2 days | 30 days |

Deferral and deadline values are limited to 1 to 20 days. Autopatch does not set deadlines on Sundays; a Sunday deadline moves to Monday.

| Workload | Setting |
| --- | --- |
| Quality updates | On for all tiers. |
| Feature updates | On, pinned to a single target version across all rings. Advance the pin only after Test has run the new version for at least 30 days. |
| Driver and firmware | Tier 1 and 2: automatic approval. Tier 3 or any tenant with specialty hardware (imaging, CNC, POS, lab): manual approval, reviewed monthly. |
| Microsoft 365 Apps | On. Monthly Enterprise Channel is mandatory for registered devices. Note that Intune cannot pause or roll back an Office update once released. |
| Microsoft Edge | On, Stable channel unless the customer has an app dependency on Extended Stable. |
| Release schedule preset | Information worker for `MSP-WIN-APG-CORP`. Shared device, Kiosks and billboards, or Reboot-sensitive for the corresponding separate Autopatch group. |

### Hotpatch

Since the May 2026 security update, Autopatch enables hotpatch by default for eligible devices. Eligibility requires Windows 11 24H2 or later, the current quarterly baseline installed, VBS running, and an eligible license (Business Premium qualifies). Ineligible devices silently receive the normal cumulative update instead, so nothing breaks; they just keep rebooting.

Practical points:
- Baseline months (January, April, July, October) still require a restart. Hotpatch months are the other eight.
- Upgrading Windows during a hotpatch month drops the device back to standard updates until the next baseline.
- Arm64 devices need CHPE disabled to apply hotpatches. If the customer still runs 32-bit Office or legacy x86 add-ins on Arm hardware, leave those devices out of hotpatch (`MSP-WIN-UPD-EXCL-NoHotpatch-Arm64`).
- Check the Hotpatch quality update report to confirm what devices actually receive, rather than assuming eligibility from the license alone.


## Build procedure

1. Verify licensing, device SKUs, and that app-only auth is on. Clean up stale Entra device records.
2. Create the device groups from Section 3.3. Populate `RING0-TEST` and `RING9-LAST` by hand and confirm no device is in both.
3. Confirm the pool group's dynamic rule returns the expected device count before going further.
4. Tenant administration > Windows Autopatch > Autopatch groups > Create. Name it per Section 3.4.
5. Add the rings for the tier. Assign Test and Last their assigned groups; set dynamic distribution for the middle rings so percentages total 100.
6. Select update types (Section 5), deployment settings, and the release schedule preset. The preset is permanent for this group.
7. Add the customer's scope tag if the tenant uses them, then Review + create.
8. Wait up to 48 hours, then review the Autopatch group membership report. Resolve every Not registered and Not ready device before telling the customer the build is complete.
9. Fill in the record sheet in Section 10 and file it with the customer documentation.
10. Send the customer a short note covering restart behavior, deadlines, the Office channel change if applicable, and who to contact.


## Conditional Access and compliance interactions

The ConditionalAccessBaseline is user-based and does not target Autopatch's device groups, so there is no direct conflict. The interactions that do bite:

| Policy | Interaction | Action |
| --- | --- | --- |
| `CA203-Internals-AppProtection-MicrosoftIntuneEnrollment-AnyPlatform-MFA` | Autopilot Device Preparation enrollment can hang in OOBE because automated enrollment cannot satisfy MFA. | Add the Autopilot device preparation account or users to that policy's exclusion group before imaging replacement devices. |
| `CA205-Internals-BaseProtection-AnyApp-Windows-CompliantorAADHJ` | Requires a compliant or hybrid-joined Windows device. If a compliance policy uses a minimum OS build tied to the newest release, a paused or deferred ring can turn into a sign-in outage. | Never set minimum OS version above the version the slowest ring has already reached. Keep a compliance grace period of at least 3 days. |
| `CA205` (known issue) | Windows first sign-in restore can be blocked. | Exclude Microsoft Activity Feed Service (`d32c68ad-72d2-4acb-a0c7-46bb2cf93873`) in that policy. |
| BitLocker, Defender, ASR, LAPS baselines | Update-driven reboots and feature updates can briefly flip encryption or Defender signature state, which can flip compliance. | Grace period plus a Not compliant alert to the Svetek queue, not to the end user. |

When pausing a ring for an incident, check whether the pause pushes any device outside a compliance rule before the pause expires.


## Operations

| Task | Method |
| --- | --- |
| Move one device to another ring | Autopatch group membership report > select device > Assign ring. Requires Windows Autopatch Group read at minimum. Scoped admins can only move devices within the same Autopatch group and scope tag. |
| Add a new device | It joins the pool group automatically via the dynamic rule. Nothing else is needed unless it belongs in Test or Last. |
| Remove a device | Removing it from the source Entra group deregisters it from Autopatch and drops all Autopatch-created policies. Confirm that is the intent before removing. |
| Motherboard, NIC, or system drive replacement | A new Entra device ID is generated. The device must be re-added to the ring or pool group even though it is physically the same machine. |
| Reimage or refresh | No action. The Entra device ID is preserved. |
| Pause a bad quality or feature update | Pause on the affected update ring, then pilot the fix in Test before resuming. Driver updates pause separately. |
| Roll back a hotpatch | No automatic rollback. Uninstall the hotpatch, install the current cumulative update, restart. |
| Microsoft 365 Apps rollback | Not available through Intune. Use the Microsoft 365 Apps admin center. |
| Editing during a release | An Autopatch group cannot be edited while a feature update release is targeting it. Plan ring changes between releases. |
| Monthly review | Autopatch group membership report, quality update report, hotpatch report, and any Not ready devices. Note anything sitting past deadline in the customer's monthly summary. |


## Common failure causes

| Symptom | Likely cause |
| --- | --- |
| Not registered, Prerequisites failed | Not Intune-managed, personal ownership, unsupported SKU, or a stale Entra device record with no Intune ID. |
| Not registered, Autopatch group conflict | Same device in rings across two Autopatch groups, or overlapping source groups. Pick one group manually. |
| Not ready | No Intune check-in in 28 days, failed post-registration readiness check, or a policy conflict. |
| Ring distribution does not match percentages | Fewer than 100 devices in the Autopatch group. Switch that ring to assigned membership. |
| Test devices receiving production timing | Device is a member of both an earlier and a later assigned ring; the later ring wins. Fix group membership. |
| Devices still rebooting monthly | Not hotpatch-eligible: Windows 10, pre-24H2, VBS off, or not on the current baseline. |
| Office not updating | No Intune check-in in 5 days, Office apps never closed, CDN endpoints blocked, or a competing Office update policy. |


## Per-tenant record sheet

| Field | Value |
| --- | --- |
| Customer / tenant | |
| Date built / by | |
| Device count at build | |
| Tier applied (1 / 2 / 3) | |
| Licensing (Business Premium / E3 / other) | |
| Autopatch group name(s) | |
| Release schedule preset | |
| Ring count and membership method | |
| Test ring devices (name / user) | |
| Last ring devices and why | |
| Excluded devices and why | |
| Deferral / deadline / grace per ring | |
| Feature update target version pinned | |
| Driver approval: automatic or manual | |
| Office channel before build | |
| Hotpatch eligible device count | |
| Compliance minimum OS version setting | |
| CA exclusions added | |
| Customer notified (date / method) | |


## Change log

| Version | Date | Change |
| --- | --- | --- |
| 1.0 | 2026-07-28 | Initial article. |
