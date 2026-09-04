---
title: "Caller Identity Glossary: CNAM, LIDB, STIR/SHAKEN, and Branded Calling"
seo_title: "CNAM vs LIDB vs STIR/SHAKEN vs Branded Calling | VoIP Glossary"
description: "Technician glossary explaining CNAM, LIDB, STIR/SHAKEN, and branded caller ID for VoIP and telecom deployments."
keywords: "CNAM vs LIDB, STIR SHAKEN vs CNAM, branded caller ID, branded calling, VoIP caller identity, caller name lookup, telecom glossary, MSP VoIP support, IT support Vancouver WA, IT support Portland OR, IT support Seattle WA"
canonical: https://help.svetek.com/docs/Configuration/Telephony/caller-identity-glossary/
og_title: "Caller Identity Glossary: CNAM, LIDB, STIR/SHAKEN, and Branded Calling"
og_description: "A technician reference for the caller-identity terms commonly mixed together in VoIP deployments."
og_type: article
og_image: https://help.svetek.com/images/logo_horizontal_whitetext.svg
og_url: https://help.svetek.com/docs/Configuration/Telephony/caller-identity-glossary/
published_time: 2026-08-13T00:00:00+00:00
twitter_title: "CNAM, LIDB, STIR/SHAKEN, and Branded Calling"
twitter_description: "Technician glossary for VoIP caller identity, verification, and mobile call branding."
twitter_image: https://help.svetek.com/images/logo_horizontal_whitetext.svg
twitter_image_alt: "Svetek logo"
layout: docs
---

Use this reference when configuring or explaining outbound caller identity for a VoIP or telecom deployment. These terms describe different parts of the call ecosystem. They are related, but they are not interchangeable.

## Quick Answer

- **CNAM** is the caller-name data or service you want a recipient to see.
- **LIDB** is one of the database mechanisms historically used to store and retrieve caller-name information.
- **STIR/SHAKEN** authenticates the calling number's relationship to the originating provider; it does not set the displayed name.
- **Branded caller ID** or **Branded Calling** is a separate, carrier-supported mobile experience that can show a verified name and, where supported, a logo and call reason.

## Comparison

| Term | What it does | What it does not do |
| --- | --- | --- |
| **CNAM** (Caller ID Name) | Associates a business or caller name with a telephone number for caller-name display. | Does not guarantee every recipient sees that name. It does not authenticate the call or remove spam labels. |
| **LIDB** (Line Information Database) | Refers to the network database infrastructure used for line-information queries, including caller-name data in traditional North American CNAM workflows. | Is not the caller name itself, a caller-ID display product, or an anti-spoofing standard. |
| **STIR/SHAKEN** | Lets a provider sign and a terminating provider verify caller-ID information and the caller's relationship to the number. | Does not publish a CNAM record, guarantee a name/logo display, or prove that a call is welcome, legitimate in every respect, or not spam. |
| **Branded Calling** | Delivers verified brand information to supported mobile recipients; depending on the product, this can include a display name, logo, and call reason. | Does not provide universal coverage, replace CNAM on landlines, or override the recipient carrier's spam/reputation controls. |

## CNAM: Caller ID Name

CNAM is the text name associated with a calling telephone number, such as `SVETEK` or `ACME SERVICES`. In the United States, caller-name display often depends on the **terminating carrier** querying one or more caller-name data sources when the call arrives.

The originating VoIP provider can submit or register outbound CNAM, but that does **not** guarantee that every called party sees the requested name. The recipient's carrier, device, plan, and caller-ID/reputation services determine what is ultimately presented. The recipient carrier can use its own data, a third-party lookup, cached data, a contacts list, or no caller-name display at all.

Common results for the same number include:

- The requested business name on one carrier.
- A previous or stale name on another carrier.
- A city/state, number only, or no name.
- A contacts-list name stored by the recipient.
- A carrier-generated spam or fraud label instead of, or in addition to, caller-name information.

For US numbers, providers can impose eligibility, vetting, character, and number-type rules. Verify the provider's current requirements before promising a client a particular CNAM display.

### Toll-Free Numbers

Toll-free CNAM/LIDB handling can be a provider-specific exception. For example, Bandwidth's CNAM/LIDB API does not support adding toll-free numbers. When this applies, email the provider's support team with:

- The toll-free telephone number.
- Subscriber information.
- Use type.
- The desired visibility.

Do not assume this limitation applies to every carrier. Confirm the provider's current toll-free CNAM process before submitting a request or promising a display outcome.

## LIDB: Line Information Database

LIDB is a telecom database term. In caller-name discussions, it commonly refers to the database infrastructure that holds or is queried for line information, including CNAM records. Providers may refer to **LIDB updates**, **CNAM provisioning**, or **CNAM publishing** when they submit caller-name data to those industry data sources.

Use this distinction when communicating with carriers:

- “Set the **CNAM** to `ACME SERVICES`” describes the desired caller-name data.
- “Submit an **LIDB update**” describes one mechanism used to publish that data.

LIDB is not a promise of universal delivery. Terminating carriers can choose their own lookup and presentation behavior, and CNAM data can be cached or sourced differently across networks.

## STIR/SHAKEN: Caller-ID Authentication

STIR/SHAKEN is a caller-ID authentication framework for IP-based voice calls. The originating provider signs the call's caller-ID information, and downstream providers can verify that signature. The attestation level represents what the originating provider knows about the caller and the caller's right to use the presented number.

For operations, treat STIR/SHAKEN as **number authentication**, not identity display:

- It helps establish trust in the calling number and supports downstream analytics and anti-spoofing decisions.
- It can contribute to a recipient carrier's verification, spam-labeling, blocking, or call-treatment decision.
- It does not write a CNAM record, set a business name, add a logo, or guarantee a “Verified” indicator.
- A high attestation level is not a blanket certification that the caller is legitimate or that the recipient carrier will not label the call as spam.

Configure the provider's STIR/SHAKEN registration and number association when available, especially for business outbound calling. Keep the legal entity, authorized numbers, and caller-ID presentation aligned with the provider's verification records.

## Branded Caller ID: Mobile Call Presentation

**Branded caller ID** is a general term. Providers may call their product **Branded Calling**, **Branded Call Display**, or a similar name. It is a separate service that can present verified business identity on supported mobile networks and handsets.

Depending on carrier coverage and product tier, the recipient may see:

- A verified display name.
- A company logo.
- A call reason, such as `Appointment Reminder` or `Customer Support`.

Branded Calling is not the same as CNAM:

- It targets supported mobile recipients; CNAM is generally the relevant caller-name mechanism for landline presentation.
- It can require business verification, brand assets, a letter of authorization, number registration, and provider-specific enrollment.
- Support varies by country, mobile carrier, handset, operating system, and product availability.
- It does not override contacts, device settings, carrier spam analytics, blocking, or reputation labels.

## How the Pieces Work Together

For a US business making outbound VoIP calls, use the following layered approach:

1. **Caller ID number**: Present only numbers the client owns or is authorized to use.
2. **STIR/SHAKEN**: Register the business and numbers with the provider so the provider can authenticate calls appropriately.
3. **CNAM/LIDB**: Submit the approved business caller name for eligible US telephone numbers.
4. **Branded Calling**: Enroll when supported mobile display name, logo, or call reason is a business requirement.
5. **Voice reputation**: Monitor spam labeling and use the provider's reputation or Voice Integrity process where applicable.

These controls complement one another. None guarantees a universal recipient display or prevents every spam label, block, or call-screening action.

## Technician Communication and Validation

Set the following expectation before completing a client request:

> We can register the requested caller identity with the VoIP provider, but the receiving carrier controls how a specific recipient sees the call. The displayed name, verification indicator, branding, and spam label can vary by carrier, handset, recipient settings, and reputation service.

When validating a change:

1. Record the provider, telephone number, requested CNAM, business profile, and approval date.
2. Confirm the provider reports the CNAM, STIR/SHAKEN, and Branded Calling registrations as approved or active, as applicable.
3. Test calls to multiple carriers and device types; do not rely on a single test handset.
4. Record the displayed number, name, verification indicator, branded elements, and any spam label for each test.
5. Allow for provider and carrier propagation or cache refresh time before escalating a display mismatch.
6. If the issue is a spam label, use the provider's reputation-remediation process; do not treat a CNAM change alone as a remediation.

## Common Misstatements to Avoid

| Do not say | Say instead |
| --- | --- |
| “We set CNAM, so everyone will see this name.” | “We registered the caller name; display varies by terminating carrier and recipient device.” |
| “LIDB is our branded caller ID.” | “LIDB is a database mechanism that can support CNAM data.” |
| “STIR/SHAKEN makes the call safe or removes spam labels.” | “STIR/SHAKEN authenticates caller-ID information and can inform downstream call-treatment decisions.” |
| “Branded Calling replaces CNAM.” | “Branded Calling and CNAM are separate services for different presentation paths and recipients.” |

## Related Resources

- [Twilio: Brand Your Calls Using CNAM](https://www.twilio.com/docs/voice/brand-your-calls-using-cnam)
- [Twilio: Trusted Calling with STIR/SHAKEN](https://www.twilio.com/docs/voice/trusted-calling-with-shakenstir)
- [Twilio: Branded Calling Overview](https://www.twilio.com/docs/voice/branded-calling)
- [FCC: Caller ID Authentication Through STIR/SHAKEN](https://docs.fcc.gov/public/attachments/FCC-20-42A1.pdf)
- [Voice Integrity to Remediate Spam Labels](/docs/Configuration/Twilio/Voice_Integrity/)

## Need Help

Svetek supports VoIP caller-identity configuration, including business verification, CNAM registration, STIR/SHAKEN, branded calling, and spam-label remediation. Include the carrier, affected numbers, requested display, destination carriers tested, and screenshots of actual call presentation in the service request.
