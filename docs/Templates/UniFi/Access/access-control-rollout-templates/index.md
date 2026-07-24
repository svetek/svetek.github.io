---
title: "UniFi Access Control Rollout Templates"
seo_title: "UniFi Access Control Rollout Templates | Apartment and Office Guide"
description: "Email, handout, emergency procedure, and admin cheat sheet templates for rolling out UniFi Access in small apartment buildings or small offices."
keywords: "UniFi Access templates, access control rollout email, key fob enrollment template, UniFi Identity invite template, building access handout, access control emergency procedures, MSP UniFi Access rollout, IT support Vancouver WA, IT support Portland OR, IT support Seattle WA"
canonical: https://help.svetek.com/docs/Templates/UniFi/Access/access-control-rollout-templates/
og_title: "UniFi Access Control Rollout Templates"
og_description: "Reusable communication and operations templates for UniFi Access rollouts in small buildings and offices."
og_type: article
og_image: https://help.svetek.com/images/logo_horizontal_whitetext.svg
og_url: https://help.svetek.com/docs/Templates/UniFi/Access/access-control-rollout-templates/
published_time: 2026-07-24T00:00:00+00:00
date: 2026-07-24
tags:
  - UniFi Access
  - Access Control
  - Templates
  - Client Communication
twitter_title: "UniFi Access Rollout Templates"
twitter_description: "Email, handout, emergency, and admin templates for UniFi Access rollouts."
twitter_image: https://help.svetek.com/images/logo_horizontal_whitetext.svg
twitter_image_alt: "Svetek logo"
layout: docs
---

Use these templates for small apartment buildings or small offices using UniFi Access. They can also be adapted to similar access control systems.

Replace all bracketed placeholders before use. Delete whichever wording does not apply, such as apartment-specific or office-specific language.

## Template 1: Announcement and Information Request Email

**Subject:** New building access system - action needed by `[DATE]`

Hi `[TENANT NAME / TEAM]`,

We are upgrading building access at `[ADDRESS]` to an electronic system starting `[INSTALL DATE]`. Here's what you need to know:

**What's changing**

- Entry doors will use key fobs and optional smartphone access.
- Your current physical key will continue to work as backup.
- Exit is unchanged: the interior handle always opens the door.

**What we need from you by `[DATE]`**

Reply to this email with:

1. Your preferred email address, required for enrollment.
2. Whether you want smartphone access in addition to your fob: yes or no.
3. How many fobs you need: `[1/2]` included, extras `$[XX]` each.

Your email will be used only for access system enrollment and building communications related to this system.

**Enrollment day**

Fobs will be handed out on `[DATE]` between `[TIME]` and `[TIME]` at `[LOCATION]`. It takes about 10 minutes. If you cannot make it, contact me to arrange another time.

Questions? Reply here or call `[PHONE]`.

`[NAME]`  
`[TITLE]`

## Template 2: Enrollment Confirmation and Mobile Invite Email

**Subject:** Your building access is ready - next steps

Hi `[NAME]`,

Your access credentials for `[ADDRESS]` are set up.

**Your fob(s):** `[SERIAL / QTY]` - issued `[DATE]`. Tap the fob on the black reader next to the door. The light turns green and the door unlocks.

**Smartphone access, if you opted in:** You will receive a separate email invitation from UniFi Identity. Steps:

1. Open the invitation email on your phone.
2. Install the UniFi Identity app from the App Store or Google Play.
3. Create your account using this same email address.
4. Accept the invitation. Your phone is now a key.
5. At the door, open the app and tap **Unlock**, or hold your phone to the reader.

**Deliveries and guests:** From the UniFi Identity app, you can create a temporary PIN with a time window and share it with a delivery driver or guest. They enter it on the intercom keypad. The PIN expires automatically.

**If something does not work:** Your physical key still opens the door. Then contact `[NAME]` at `[PHONE / EMAIL]`.

`[NAME]`

## Template 3: One-Page User Handout

**`[BUILDING NAME]` Door Access Quick Guide**

**Getting in**

- **Fob:** Tap it flat against the reader. Green light means unlocked. Pull the door within `[5]` seconds.
- **Phone:** Open the UniFi Identity app and tap **Unlock**, or hold the phone to the reader.
- **Physical key:** Always works. Keep it as your backup.

**Getting out**

- Turn the interior handle. It always works, even in a power outage.

**Intercom, main entrance**

- Visitors find your `[unit number / name]` on the screen and press **Call**.
- You answer on your phone in the UniFi Identity app and can unlock the door remotely.

**Deliveries and guests**

- In the UniFi Identity app: create a PIN, set a time window, and share the code.
- The driver or guest enters the code on the intercom keypad. The code expires on its own.

**Lost fob or phone?**

- Report it immediately to `[NAME]` at `[PHONE / EMAIL]`. We deactivate it in minutes. Replacement fob: `$[XX]`.

**Door will not open or system seems down?**

- Use your physical key. Then report it to `[PHONE / EMAIL]`.

**Power outage?**

- The system runs on battery for about an hour. After that, use your physical key. Exit is never affected.

Contact for all access issues: `[NAME]` - `[PHONE]` - `[EMAIL]`

## Template 4: Emergency Procedures, Internal

**Access System Emergency Procedures - `[ADDRESS]`**

Keep a printed copy at `[LOCATION]` and a digital copy at `[LOCATION]`.

**Escalation contacts, in order**

1. `[PROPERTY MANAGER / OFFICE MANAGER]` - `[PHONE]`
2. `[BACKUP CONTACT]` - `[PHONE]`
3. `[INSTALLER / IT SUPPORT]` - `[PHONE]`
4. `[ELECTRICIAN, if power-related]` - `[PHONE]`

**Person locked out, fob or phone not working**

1. Verify identity using the roster, lease, or staff list.
2. Remote-unlock from the UniFi Access app or web console, or meet them with the master key.
3. Next business day: check their credential in UniFi Access and reissue if needed.

**Lost or stolen fob**

1. Open **UniFi Access** > **Users**.
2. Find the person.
3. Deactivate that fob immediately.
4. Log it in the credential spreadsheet.
5. Issue a replacement and record the new serial.

**Whole system down, readers dark, or app offline**

1. Physical keys still work. Inform anyone affected.
2. Check whether building power is on, whether the UPS is beeping, and whether the network rack is powered.
3. Power-cycle in this order if needed: gateway, switch, then wait 5 minutes.
4. If still down, call `[INSTALLER / SUPPORT]`.
5. Doors remain locked to the outside, fail-secure, and always open from inside.

**Power outage**

1. System runs on UPS for roughly `[1 hour]`.
2. After UPS depletion, entry is by physical key only. Exit is unaffected.
3. When power returns, the system restarts on its own. Verify both doors within `[24h]`.

**Fire or emergency responders need access**

1. Exit doors always open from inside. Evacuation is never blocked.
2. Fire or police entry: `[master key location / knox box / on-call contact meets them]`.
3. After the event, review access logs and door status.

**Suspected unauthorized access**

1. Note date, time, and door.
2. Pull the access log in UniFi Access and the camera footage for that time.
3. Deactivate any suspect credential.
4. Report to `[OWNER / POLICE if warranted]`.

## Template 5: Admin Cheat Sheet, Internal

**UniFi Access Admin Cheat Sheet - `[ADDRESS]`**

Console: `[URL or app]`  
Admin account: `[ACCOUNT NAME]`  
Do not share the admin login.

**Add a new person, tenant, or employee**

1. Open **UniFi Access** > **Users** > **Add User**.
2. Enter name, `[unit/department]`, and email.
3. Assign to group: `[Tenants / Staff]`.
4. For fob access, select **Assign NFC Card**, tap the new fob on the enrollment reader, and save.
5. For phone access, choose **Invite** in their profile. They receive the UniFi Identity email.
6. Record fob serial, name, and date in the credential spreadsheet.
7. Have them test both doors before they leave.

**Remove a person, move-out, or departure**

1. Open **Users**.
2. Select the person.
3. Deactivate all credentials on the departure date, not later.
4. Collect their fob or fobs.
5. Note return in the spreadsheet.
6. Their phone credential dies with the deactivation. Nothing else is needed.

**Replace a lost fob**

1. Open **Users**.
2. Select the person.
3. Remove the lost fob credential.
4. Assign a new fob.
5. Update the spreadsheet.
6. Collect replacement fee `$[XX]`, if applicable.

**Give a vendor temporary access**

1. Add them as a user in the `[Vendors]` group with a business-hours schedule.
2. Prefer a dated expiration on the credential.
3. Remove them when the job ends.

**Check who came in**

1. Open **UniFi Access** > **Logs** or **Activity**.
2. Filter by door and date.
3. Review the credential and person shown for each entry.
4. Cross-reference camera footage in UniFi Protect for the same timestamp, if cameras cover the entrance.

**Quarterly 15-minute audit**

1. Export the user list.
2. Compare it with the current roster.
3. Deactivate anyone who should not be there.
4. Spot-check the UPS: no beeping, battery status OK.

**Golden rules**

- One admin account per real person. Never share logins.
- Deactivate credentials the same day someone leaves.
- Never hand out a permanent shared PIN.
- The spreadsheet is only useful if it is current. Update it at the moment of issue or return.

## Need Help

For UniFi Access deployments in Vancouver WA, Portland OR, Seattle WA, and remote client environments, Svetek can help plan access control rollout communication, configure UniFi Access, document emergency procedures, and train property or office administrators.
