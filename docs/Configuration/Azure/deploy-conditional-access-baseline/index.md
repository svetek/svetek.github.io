---
title: "Deploy a Conditional Access Baseline in Microsoft Entra"
seo_title: "Deploy Conditional Access Baseline in Entra ID | MSP Guide"
description: "Deploy the j0eyv ConditionalAccessBaseline policy set into a Microsoft Entra tenant using IntuneManagement, Git, or CIPP, with report-only validation and MSP-scale guidance."
keywords: "Conditional Access baseline, Entra ID Conditional Access, Microsoft 365 security baseline, IntuneManagement Conditional Access import, CIPP Conditional Access framework, MSP Microsoft 365 security, IT support Vancouver WA, IT support Portland OR, IT support Seattle WA"
canonical: https://help.svetek.com/docs/Configuration/Azure/deploy-conditional-access-baseline/
og_title: "Deploy a Conditional Access Baseline in Entra ID"
og_description: "A practical MSP guide to deploying the j0eyv ConditionalAccessBaseline with IntuneManagement, Git, or CIPP."
og_type: article
og_image: https://help.svetek.com/images/logo_horizontal_whitetext.svg
og_url: https://help.svetek.com/docs/Configuration/Azure/deploy-conditional-access-baseline/
published_time: 2026-07-04T00:00:00+00:00
date: 2026-07-04
tags:
  - Microsoft Entra
  - Conditional Access
  - Microsoft 365
  - CIPP
  - IntuneManagement
twitter_title: "Deploy a Conditional Access Baseline"
twitter_description: "Deploy the j0eyv ConditionalAccessBaseline safely with report-only validation and a path from GUI to Git to CIPP."
twitter_image: https://help.svetek.com/images/logo_horizontal_whitetext.svg
twitter_image_alt: "Svetek logo"
layout: docs
---

# Deploy a Conditional Access Baseline in Microsoft Entra

The [j0eyv ConditionalAccessBaseline](https://github.com/j0eyv/ConditionalAccessBaseline) is a practical starting point for Microsoft Entra Conditional Access. It gives you a numbered policy set, supporting groups, named locations, and a persona model that helps you reason about who each policy protects.

This guide is for the first deployment into a Microsoft 365 tenant. You can deploy the same baseline three ways:

- **IntuneManagement GUI** for a hands-on single-tenant deployment.
- **Git workflow** when you want the baseline to become reviewed source control.
- **CIPP** when you manage multiple tenants and want standards, templates, and drift visibility.

These are not three unrelated approaches. They are three rungs on the same maturity ladder. You can start with the GUI to learn the policy set, move your customized JSON into Git when repeatability matters, and later use CIPP when the job becomes managing a fleet instead of one tenant.

This page was checked on **July 4, 2026**. Conditional Access, CIPP, IntuneManagement, and the upstream baseline all change over time, so confirm the upstream docs before deploying into a production tenant.

For ongoing maintenance after the first deployment, use the companion guide: [Refresh and Diff a Deployed Conditional Access Baseline](/docs/Configuration/Azure/refresh-conditional-access-baseline/).

## What This Baseline Protects

The baseline organizes Conditional Access around personas rather than one giant policy list. The current rendered README describes personas for global controls, administrators, internal users, service accounts, guests, and agents. That structure matters because Conditional Access is evaluated as a combined access decision, not as a simple firewall-style top-to-bottom rule list.

Conceptually, the baseline covers:

- **Global controls** such as all-app multifactor authentication, country-based access restrictions, legacy authentication blocking, registration or join protections, authentication flow controls, and app protection requirements.
- **Administrator controls** such as MFA for admin portals, MFA for privileged roles, sign-in frequency limits, persistent browser session controls, Continuous Access Evaluation, and phishing-resistant MFA.
- **Internal user controls** such as MFA, risk-based blocking, sign-in frequency controls, device compliance requirements, app restrictions, and platform restrictions.
- **Service account controls** to separate and restrict accounts that should not behave like normal interactive users.
- **Guest controls** to require MFA, limit access, and reduce persistent session risk.
- **Agent controls** for newer Conditional Access scenarios involving agent identities and agent users.

As of this review, the repository's `Config/ConditionalAccess` folder contains **38 Conditional Access JSON files**, while the rendered README index describes **36 policy numbers**. The difference is not mysterious: the file tree includes alternate CA005 and CA006 JSON variants. Treat the README as the conceptual guide, but treat the file tree as the deployment truth when importing.

The numbered names are useful operationally. If you see `CA000`, you know it is a global baseline policy. If you see `CA2xx`, you are in internal-user territory. If you see `CA5xx`, you are looking at agent-related policy coverage. That makes reviews, imports, and incident investigation less chaotic.

## Universal Prerequisites

Before you import anything, confirm the tenant is ready.

- The tenant has Microsoft Entra ID P1 licensing for Conditional Access. Risk-based policies require Entra ID P2 because they depend on Microsoft Entra ID Protection.
- Security defaults are disabled before importing Conditional Access policies. The upstream baseline calls this out as a prerequisite.
- At least one emergency access account exists, is excluded from the policy set, and has been tested before you touch enforcement.
- You have the right administrative access. Use the least privilege that can complete the work; Conditional Access Administrator and Security Reader are usually better than living in Global Administrator all day.
- You know which countries, networks, and locations the client actually allows. The upstream baseline's country whitelist is not your client's whitelist.
- You know which user groups represent internal users, admins, service accounts, guests, and exceptions.
- You have a rollback path: export or document the current state before importing new policy objects.

The break-glass account is not paperwork. It is how you avoid turning a good security project into a tenant lockout. Create it first, exclude it first, sign in with it first, and record where the credentials and MFA method are stored.

## The Golden Rule: Start Report-Only or Off

Do not import a full Conditional Access baseline straight to **On**.

Microsoft's report-only mode lets you evaluate most Conditional Access policies during sign-in without enforcing the grant or session controls. The results appear in sign-in logs, and tenants with the right logging setup can review policy impact through Conditional Access workbooks.

Use this order for a safer first rollout:

1. Verify emergency access works.
2. Import the baseline in **Report-only** or **Off**.
3. Review every included group, excluded group, named location, app scope, and platform condition.
4. Enforce the broad all-app MFA control only after test sign-ins behave as expected.
5. Leave geo or country restrictions in report-only long enough to catch travel, VPN, vendor, and service-provider patterns.
6. Move policies to **On** in deliberate groups, not as one giant switch.

One important exception: some Continuous Access Evaluation policies cannot be created in report-only mode. Where the tool or service does not support report-only for a specific policy, leave that policy off until you are ready to enforce it deliberately.

Also be precise about legacy authentication. Blocking legacy authentication is still important, but it does not magically close every password-based OAuth path. Microsoft's ROPC documentation says the flow is incompatible with MFA. The practical mitigation is enforced MFA coverage for users and apps that can be interactively challenged, plus removal or replacement of apps that still depend on risky password flows.

## Method A: Deploy with IntuneManagement GUI

[IntuneManagement](https://github.com/Micke-K/IntuneManagement) is the most approachable first-deploy path. It uses PowerShell, Microsoft Graph, Azure APIs, and a WPF interface to export, import, compare, copy, delete, and document Intune and Azure objects. The upstream ConditionalAccessBaseline README also uses this tool for import instructions.

Use this method when you have one tenant, want to inspect the baseline interactively, and do not yet need a full GitOps workflow.

Start by downloading the latest IntuneManagement release or repository copy from GitHub. Run it from a workstation where you can execute PowerShell scripts. The upstream instructions include unblocking downloaded `.cmd`, `.ps1`, and `.psd1` files before launch.

When you authenticate, be careful with the consent prompt. The upstream baseline's instructions warn not to consent on behalf of the organization during this flow. Follow the current IntuneManagement behavior in front of you because button labels and consent prompts can shift between versions.

For the import sequence, respect dependencies:

1. Import **Groups** first.
2. Import **Named Locations** second.
3. Import **Conditional Access** policies last.

That order matters. CA001 depends on the named location used for allowed countries. If the named location is missing or mismatched, the policy cannot resolve correctly. IntuneManagement's import behavior is designed around exported JSON and a migration table that maps IDs and names from the exported source to the destination tenant. Its README explains that dependencies need the related exported JSON files available so the tool can update object IDs before import.

During Conditional Access import:

- Set the Conditional Access state to **Report-only** or **Off**.
- Include dependencies so groups and named locations resolve.
- Review whether assignments should import as-is or be reassigned manually.
- Expect UI wording to vary. Match the intent of the option, not just the exact label shown in someone else's screenshot.

After import, perform a cleanup pass in the Entra admin center:

- Replace sample groups with the client's real groups where appropriate.
- Confirm every break-glass and emergency access exclusion.
- Change the allowed countries named location from the upstream default to the client's actual approved list.
- Check service accounts and service-provider access separately from human users.
- Confirm app scopes such as Office 365, Microsoft Admin Portals, Intune enrollment, and selected blocked applications.
- Leave high-impact block policies in report-only until sign-in data confirms the expected effect.

This method is good for learning the baseline because you see the objects arrive in the tenant. Its weakness is long-term maintenance. A GUI import is not a true merge strategy. That is why the refresh workflow lives in the companion article.

## Method B: Deploy from a Git Workflow

The Git workflow uses the same baseline but changes where the truth lives. Instead of treating the tenant as your only source of truth, you keep the customized JSON in a repository.

Use this method when you want reviewable changes, repeatable deployments, and a cleaner path for multiple clients.

A practical pattern looks like this:

1. Fork or vendor the upstream `j0eyv/ConditionalAccessBaseline` repository.
2. Add the upstream repository as a remote so you can track future changes.
3. Create a branch for your common MSP baseline.
4. Create per-tenant branches only when a client needs documented differences.
5. Customize named locations, group assignments, excluded accounts, app scopes, and policy states in files.
6. Deploy the reviewed files using IntuneManagement, Microsoft Graph, or your preferred automation.

The payoff is not that Git magically deploys Conditional Access. The payoff is that Git makes the change visible before the deployment. You can see that CA005 changed, that CA201 split behavior into CA201 and CA210, or that new CA50x agent policies appeared upstream. You can review those changes before they touch a client tenant.

For a first deployment, Git also gives you a lightweight approval process:

- Pull request shows exactly which JSON files changed for the client.
- Reviewer confirms break-glass exclusions, named locations, and state values.
- Deployment happens from a known commit.
- Rollback means redeploying the prior known-good commit or restoring the pre-deploy export.

For MSPs, this becomes much cleaner than keeping a folder named `ClientA-final-final-v3`. You can maintain one common baseline and branch only for actual client differences.

Do not overcomplicate the first deployment. If you are new to the baseline, it is fine to test with IntuneManagement first, export the result, then bring the cleaned JSON into Git. Just do not stop at a one-time import if you expect to operate this for many tenants.

## Method C: Deploy with CIPP

[CIPP](https://docs.cipp.app/) is the MSP-scale path. It changes the discussion from "how do I import these policies once?" to "how do I keep many tenants aligned?"

CIPP's Template Library documentation currently lists a Conditional Access Framework community repository that points to the same `j0eyv/ConditionalAccessBaseline` source. That is the through-line: CIPP is not a separate Conditional Access philosophy here. It is another operating model for the same baseline family.

Use CIPP when:

- You manage many Microsoft 365 tenants.
- You want tenant groups, template assignment, reporting, standards, and drift review.
- You need to know when someone changes a client tenant outside the normal process.
- You want repeatable security operations rather than heroic one-off imports.

Before enabling the Template Library, understand the overwrite behavior. The CIPP docs state that enabling template library sync can overwrite templates with the same name. Current source documentation also distinguishes tenant-based template library sync from community repository sync: tenant-based libraries sync every 4 hours, while community repository libraries sync every 7 days. If you locally edit templates with the same names as synced templates, you need a naming or override strategy.

For Conditional Access deployment in CIPP, the safer pattern is:

1. Review the imported Conditional Access framework templates.
2. Copy or rename templates before making client-specific edits.
3. Assign templates to a pilot tenant or pilot tenant group.
4. Use report and alert behavior before remediation where impact is uncertain.
5. Use Drift Management for ongoing visibility once the baseline is intentional.

CIPP Standards reapply or evaluate on a 12-hour cadence according to the current docs. Drift Management is also evaluated every 12 hours and gives a more granular view of how a tenant differs from the desired template. CIPP's FAQ currently says each tenant can be assigned only one Drift Management template, so design those templates by license tier, industry, or operating model rather than making many overlapping drift templates.

CIPP also has its own security boundary. Protect the CIPP application and MSP tenant with strong Conditional Access. If CIPP can manage many client tenants, the CIPP admin plane deserves privileged-access treatment.

## Choosing Your Rung

Choose the method that matches the operating reality:

| Situation | Best starting point |
| --- | --- |
| One tenant, first time seeing the baseline | IntuneManagement GUI |
| A few tenants with repeated deployment needs | Git workflow plus IntuneManagement or Graph deployment |
| MSP fleet with ongoing standards and drift requirements | CIPP |

There is no shame in starting with the GUI. It is often the fastest way to understand the policy set. The danger is pretending the GUI import is an operational model forever. Once you need repeatability, review, and tenant-specific differences, move the truth into Git or CIPP.

## Validate After Deployment

After import, validate before enforcement.

Use the [Conditional Access What If tool](https://learn.microsoft.com/en-us/entra/identity/conditional-access/what-if-tool) from **Microsoft Entra admin center > Entra ID > Conditional Access > Policies > What If**. Test realistic combinations:

- Normal user from a normal country.
- Admin account accessing admin portals.
- Break-glass account.
- Guest user.
- Mobile app access.
- Unmanaged Windows or macOS device.
- Service account or automation account.
- Sign-in from a blocked or unapproved country.

Then inspect sign-in logs. For policies in report-only mode, review whether each policy would have applied, succeeded, failed, or required user action. If you have the Conditional Access insights workbook available, use it to see policy impact across a larger sample instead of relying on a few manual tests.

Finally, enforce slowly. Begin with policies that reduce the largest common risks without surprising users. All-app MFA, admin MFA, and legacy authentication protections usually come before aggressive geo blocks or device-compliance requirements. Country restrictions should sit in report-only long enough to catch real travel, VPN, vendor support, and service-provider activity.

## Need Help

If you support Microsoft 365 tenants in Vancouver WA, Portland OR, Seattle WA, or nearby remote environments, Svetek can help review your Conditional Access rollout, validate break-glass access, and build a repeatable baseline process.

When you are ready to maintain the baseline after deployment, continue with [Refresh and Diff a Deployed Conditional Access Baseline](/docs/Configuration/Azure/refresh-conditional-access-baseline/).

## References

- [j0eyv ConditionalAccessBaseline](https://github.com/j0eyv/ConditionalAccessBaseline)
- [ConditionalAccessBaseline policy files](https://github.com/j0eyv/ConditionalAccessBaseline/tree/main/Config/ConditionalAccess)
- [Micke-K IntuneManagement](https://github.com/Micke-K/IntuneManagement)
- [CIPP Template Library](https://docs.cipp.app/user-documentation/tools/templatelib)
- [CIPP Standards and Drift](https://docs.cipp.app/user-documentation/tenant/standards/)
- [Microsoft Conditional Access overview](https://learn.microsoft.com/en-us/entra/identity/conditional-access/overview)
- [Microsoft report-only mode guidance](https://learn.microsoft.com/en-us/entra/identity/conditional-access/concept-conditional-access-report-only)
- [Microsoft What If tool](https://learn.microsoft.com/en-us/entra/identity/conditional-access/what-if-tool)
- [Microsoft ROPC guidance](https://learn.microsoft.com/en-us/entra/identity-platform/v2-oauth-ropc)
