---
title: "Manage Tenants and Visitor Access in UniFi Access"
seo_title: "UniFi Access Tenant Enrollment and Credential Management | MSP Runbook"
description: "Technician runbook for setting up UniFi Access administrators, enrolling tenants, assigning NFC, PIN, mobile, face, and Touch Pass credentials, and managing visitor access."
keywords: "UniFi Access tenant enrollment, UniFi Access credential management, UniFi NFC fob enrollment, UniFi Access visitor access, UniFi Touch Pass, UniFi Face Unlock, MSP access control runbook, IT support Vancouver WA, IT support Portland OR, IT support Seattle WA"
canonical: https://help.svetek.com/docs/Configuration/UniFi/Access/tenant-enrollment-management/
og_title: "Manage Tenants and Visitor Access in UniFi Access"
og_description: "A technician runbook for administering UniFi Access users, credentials, move-outs, and visitor access."
og_type: article
og_image: https://help.svetek.com/images/logo_horizontal_whitetext.svg
og_url: https://help.svetek.com/docs/Configuration/UniFi/Access/tenant-enrollment-management/
published_time: 2026-07-29T00:00:00+00:00
date: 2026-07-29
tags:
  - UniFi Access
  - Access Control
  - MSP Runbook
  - Property Management
twitter_title: "UniFi Access Tenant Management"
twitter_description: "Technician procedures for UniFi Access people, credentials, move-outs, and visitors."
twitter_image: https://help.svetek.com/images/logo_horizontal_whitetext.svg
twitter_image_alt: "Svetek logo"
layout: docs
---

Use this runbook to administer a property or office using UniFi Access. It covers named admin accounts, tenant or employee enrollment, credentials, move-outs, and visitor access.

This is an operations guide for Svetek technicians and authorized client property managers. Follow the client's approved access policy and record each credential issue, return, and removal in the client's property-management system or PSA ticket.

UniFi menu names and feature availability can change with UniFi OS, the Access application, and device firmware. Keep them current and use Ubiquiti's linked documentation for product-specific requirements.

## Before You Begin

- Confirm that the person requesting access is authorized by the client.
- Confirm the correct access policy, doors, and schedule before assigning any credential.
- Use a named administrator account for every person who manages the system. Never share a UI account.
- Document the console owner, client approver, door names, credential inventory location, and emergency contact in the client's documentation.
- Do not enable biometric, mobile, or paid credentials without client approval.

Typical deployments use a G3 Intercom or Access reader and a UniFi Access Control Hub. These steps apply regardless of the reader installed at an entry point.

## Set Up Administrator Access

UniFi Access administrators are managed in UniFi OS, not only within the Access application.

1. Sign in to the console locally or through [UniFi Site Manager](https://unifi.ui.com/).
2. Go to **UniFi OS > Settings > Admins & Users**.
3. Add the administrator's email address and assign a role that includes the Access application.
4. Have the invitee create or link their UI Account and accept the invitation.
5. Confirm the account is active and can open UniFi Access before relying on it.

Access admins can remotely unlock doors, review access activity, and manage credentials according to their assigned role. Give each manager or staff member their own account; do not use a shared building or MSP login.

On supported camera-equipped readers, an Access administrator can enter **Admin Mode** at the reader with an assigned NFC credential or PIN. See [Ubiquiti's door unlock methods guide](https://help.ui.com/hc/en-us/articles/17459303874327-Configuring-Door-Unlock-Methods-in-UniFi-Access) for supported methods and reader requirements.

## Enroll a Tenant or Employee

People are managed in **Access application > People**. Choose the enrollment type based on the access methods the person needs.

### Basic Credential-Only User

Use this for a tenant or employee who only needs an NFC card or fob and a PIN. Do not send an invitation or create a UI Account.

1. Go to **Access application > People > Create New**.
2. Enter the person's name and save without sending an invitation.
3. Assign the approved access policy and schedule.
4. Add NFC and PIN credentials as needed.
5. Record the credential identifier, issue date, recipient, and assigned access policy.

### Invited UniFi Endpoint User

Use this when the person needs **Mobile Unlock**, **Face Unlock**, or **Touch Pass**. These features require a UniFi Endpoint invitation and Smart Door Access.

1. Enable **Smart Door Access** at **Access application > Settings > Identity > Services**.
2. Create or select the person under **People**.
3. Open **Overview > Send Invitation** (or **Invite Again**) and send the invitation.
4. Have the user complete onboarding in the UniFi Endpoint app.
5. Assign the approved credential and have the user test it at the correct door.

A basic credential-only user can be upgraded later by sending an invitation from their profile.

## Assign Credentials

Issue at least one physical or locally usable backup credential for anyone who depends on phone-based or biometric access. A fob is normally the primary credential and a PIN is the backup.

### NFC Card or Fob

Register cards and fobs in **Card Inventory** before assigning them to people.

#### Register at an Access Reader

1. Go to **Access application > Settings > Card Inventory > Add New > Add NFC Card**.
2. Select a reader and click **Continue**.
3. Hold the card or fob to the reader for five seconds.
4. Follow the on-screen prompts.

#### Register with the Access Mobile App

This workflow requires compatible, current versions of UniFi Access, the Access mobile app, the reader, and the hub.

1. Enable NFC on the phone.
2. In the Access mobile app, use either **Settings > Card Inventory > Add New > Scan Card to Register** or **People > select a person > NFC Card > Add NFC Card > Scan Card to Register**.
3. Hold the card or fob to the phone's NFC sensor area for five seconds.
4. Follow the prompts to assign it.

#### Import and Assign Cards

For large enrollments, go to **Access application > Settings > Card Inventory > Add New > Import NFC Cards from CSV File**. Download the template, complete it, and import the UTF-8 CSV. Ubiquiti's current limit is 1,000 cards and 10 MB per file.

To assign a registered card, go to **People > select a person > Settings > Credentials > NFC Card > +**, select the card, and assign it.

Third-party credentials must be 13.56 MHz NFC cards or fobs and must be enabled under **Settings > Card Inventory > Third-Party NFC Cards**. Test one card before ordering in bulk. Keep all cards and fobs away from wireless chargers because heat can damage them. See [Configuring NFC Cards in UniFi Access](https://help.ui.com/hc/en-us/articles/29027025185175-Configuring-NFC-Cards-in-UniFi-Access).

### PIN

1. Go to **Access application > People > select a person > Settings > Credentials > PIN > +**.
2. Enter a PIN or generate one, then select **Add**.
3. Communicate the PIN directly and securely; do not email it in plaintext.

Each person can have one PIN. Configure the global PIN length at **Settings > General > PIN**. On supported camera-equipped readers, choose a standard or randomized keypad at **Devices > select reader > Settings > Access Methods > PIN > Keypad Layout**. See [Configuring PIN Unlock in UniFi Access](https://help.ui.com/hc/en-us/articles/29027022553239-Configuring-PIN-Unlock-in-UniFi-Access).

### Face Unlock

Face Unlock is available only on supported readers with a built-in camera. It requires Smart Door Access, a UniFi Endpoint invitation for self-service enrollment, and compatible current UniFi versions.

1. Enable **Smart Door Access** at **Settings > Identity > Services**.
2. Invite the person from **People > select person > Overview > Send Invitation**.
3. Enable Face Unlock for the reader at **Devices > select reader > Settings > Access Methods**.
4. Upload a face photo at **People > select person > Settings > Credentials > Face Photo > +**, or let the invited user add it through UniFi Endpoint.
5. Test the credential at the door with the person present.

Treat Face Unlock as a convenience credential, not the only access method. Review client privacy requirements before enabling it. [Ubiquiti's Face Unlock guide](https://help.ui.com/hc/en-us/articles/26235114109079-Configuring-Face-Unlock-in-UniFi-Access) includes current reader, software, and privacy details.

### Mobile Unlock and Remote Unlock

Mobile Unlock uses the UniFi Endpoint app and Bluetooth at the reader. Remote Unlock is a separate permission that lets a user unlock an authorized door from the app when they are not at the reader.

1. Confirm that Smart Door Access is enabled.
2. Create and invite the user under **Access application > People**.
3. Confirm the user completes UniFi Endpoint onboarding.
4. If client-approved, enable Remote Unlock at **Settings > General > Remote Unlock**.
5. Confirm the person's access policy restricts the doors and times appropriately.

See [Configuring Mobile Unlock in UniFi Access](https://help.ui.com/hc/en-us/articles/29027993126679-Configuring-Mobile-Unlock-in-UniFi-Access). Do not enable Remote Unlock for a tenant, employee, or vendor unless the client has approved that capability.

### Touch Pass

Touch Pass adds a credential to Apple Wallet or Google Wallet on compatible devices. It requires Smart Door Access, an invited user, a compatible reader, and available Touch Pass licenses.

Ubiquiti currently grants a one-time 10-pass, one-year trial to each compatible console when a compatible reader is first adopted. Additional passes are a paid service and can be automatically purchased if auto-scaling is enabled. Obtain client approval before assigning a paid pass or enabling auto-scaling.

1. Go to **Access application > Settings > Touch Pass**.
2. Assign an available pass with **Click to Assign** or **Multi-Assign**; alternatively, assign it from **People > select person > Settings > Credentials > Touch Pass > +**.
3. Send the invitation from the person's Overview page if needed.
4. Have the person add the pass through UniFi Endpoint and test it at the door.

Once a pass is added to a wallet, it cannot be transferred to another person. Suspend a pass when the user leaves. See [Configuring Touch Pass in UniFi Access](https://help.ui.com/hc/en-us/articles/27130425853079-Configuring-Touch-Pass-in-UniFi-Access) for the current supported-device, licensing, and regional requirements.

## Handle a Move-Out or Departure

Perform this on the person's final day, or immediately for an involuntary departure.

1. Go to **Access application > People > select the person**.
2. Deactivate the person to revoke access while preserving the record and activity history, or delete them when the client has approved removal.
3. Collect physical cards and fobs. Unassign each returned credential before reissuing it.
4. Suspend any Touch Pass under **Settings > Touch Pass**.
5. Remove or revoke mobile and face access with the user deactivation.
6. Update the client's credential inventory and ticket with the completion time and technician name.

## Maintain Fob Inventory

Use **Access application > Settings > Card Inventory** to view registered cards and assignments. Maintain the client-authoritative inventory in its property-management system or other approved record.

| Fob number or UID | Assigned to | Unit or department | Issued date | Returned date | Notes |
| --- | --- | --- | --- | --- | --- |
|  |  |  |  |  |  |

For bulk stock, use approved UniFi cards or Pocket Keyfobs, or verified compatible third-party 13.56 MHz credentials. Never reuse a returned card until it has been unassigned from the departing person.

## Manage Delivery Driver and Visitor Access

### Intercom Call and Remote Unlock

A visitor at a G3 Intercom can call an authorized receiver, who can respond and unlock the door remotely. Configure receivers and remote-unlock permissions according to the client's policy. Do not direct doorbell calls to an unmanaged shared account.

### Scheduled Visitor Credentials

Use UniFi Access **Visitors** for time-limited guests, vendors, and delivery drivers.

1. Go to **Access application > Settings > Visitors > Create New Visitor**.
2. Enter visitor details.
3. Set a one-time or recurring visit schedule.
4. Assign only the necessary locations, such as a door, gate, or elevator.
5. Assign approved credentials, such as a QR code, PIN, or NFC card.
6. Create the visit and send the invitation by email or SMS.

Visitor credentials are automatically revoked when the visit window ends. For requirements and optional kiosk workflows, see [Configuring Visitor Schedules in UniFi Access](https://help.ui.com/hc/en-us/articles/29026499254935-Configuring-Visitor-Schedules-in-UniFi-Access).

## Optional Security Hardening

For high-security entries, enable 2-Step Authentication per reader at **Devices > select reader > Settings**. It can require two credentials, such as an NFC card and PIN, within a defined time window. Verify reader, hub, and software compatibility first. See [Configuring Door Unlock Methods in UniFi Access](https://help.ui.com/hc/en-us/articles/17459303874327-Configuring-Door-Unlock-Methods-in-UniFi-Access).

## Troubleshooting Quick Reference

| Issue | Technician action |
| --- | --- |
| Fob does not work | Confirm the card is in Card Inventory, assigned to the correct person, and that the person's access policy applies to the door and time. |
| PIN is rejected | Confirm the PIN is assigned, the reader supports PIN, and the global PIN-length setting matches the issued PIN. |
| Face is not recognized | Confirm Face Unlock is enabled at the reader, then re-upload a well-lit, unobstructed photo and verify current device firmware. |
| Intercom does not ring | Check doorbell call receivers, their account status, remote access, and notification settings. |
| Valid credential does not unlock the door | Verify the access policy, schedule, reader status, hub relay state, door hardware, power, and cabling. |

## Related Resources

- [UniFi Access Control Rollout Templates](/docs/Templates/UniFi/Access/access-control-rollout-templates/) for client announcements, user handouts, emergency procedures, and a client admin cheat sheet.
- [Getting Started with UniFi Access](https://help.ui.com/hc/en-us/articles/17452334269975-Getting-Started-with-UniFi-Access) for current platform and deployment requirements.

## Need Help

Svetek supports UniFi Access deployments and operations for organizations and properties in Vancouver WA, Portland OR, and Seattle WA. Use the approved Svetek support channel and include the client, site, door, person, credential type, and exact error or symptom in the request.
