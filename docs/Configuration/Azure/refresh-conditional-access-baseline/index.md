---
title: "Refresh and Diff a Deployed Conditional Access Baseline"
seo_title: "Refresh Conditional Access Baseline Without Overwriting Local Changes | MSP Guide"
description: "Keep a deployed j0eyv ConditionalAccessBaseline current by safely comparing upstream changes, importing new policies, reconciling revisions, and using Git or CIPP for drift control."
keywords: "refresh Conditional Access baseline, diff Conditional Access policies, j0eyv ConditionalAccessBaseline update, IntuneManagement compare, CIPP drift management, Entra Conditional Access maintenance, MSP Microsoft 365 security, IT support Vancouver WA, IT support Portland OR, IT support Seattle WA"
canonical: https://help.svetek.com/docs/Configuration/Azure/refresh-conditional-access-baseline/
og_title: "Refresh a Conditional Access Baseline Safely"
og_description: "Learn how to update a deployed Conditional Access baseline without overwriting tenant-specific changes."
og_type: article
og_image: https://help.svetek.com/images/logo_horizontal_whitetext.svg
og_url: https://help.svetek.com/docs/Configuration/Azure/refresh-conditional-access-baseline/
published_time: 2026-07-04T00:00:00+00:00
date: 2026-07-04
tags:
  - Microsoft Entra
  - Conditional Access
  - Microsoft 365
  - CIPP
  - Drift Management
twitter_title: "Refresh a Conditional Access Baseline"
twitter_description: "Safely diff upstream Conditional Access baseline updates and preserve local tenant customizations."
twitter_image: https://help.svetek.com/images/logo_horizontal_whitetext.svg
twitter_image_alt: "Svetek logo"
layout: docs
---

This guide is for the second pass and every pass after that. You already deployed the [j0eyv ConditionalAccessBaseline](https://github.com/j0eyv/ConditionalAccessBaseline), adjusted it for a tenant, and now upstream has changed.

If you are deploying the baseline for the first time, start with [Deploy a Conditional Access Baseline in Microsoft Entra](/docs/Configuration/Azure/deploy-conditional-access-baseline/). Do not use this article as first-deploy instructions.

The maintenance problem is simple to describe and easy to get wrong: the upstream baseline evolves, but your tenant has local choices. You may have changed allowed countries, excluded break-glass accounts, adjusted admin role scope, renamed groups, or left a policy off because the client was not ready. A refresh is therefore not a button. It is a diff-and-decide operation.

This page was checked on **July 4, 2026**. Conditional Access, CIPP, IntuneManagement, and the upstream baseline change over time, so use the linked source docs when planning a production refresh.

## Why Just Re-Import Breaks

The IntuneManagement GUI is useful, but an import tool is built primarily for adding or replacing objects. It is not a three-way merge engine.

Used as a refresh mechanism, it has two failure modes:

- **Match existing names and overwrite**: the tool can replace an existing policy with the file you imported. That may destroy tenant-specific edits, such as exclusions, included groups, named locations, report-only state, or app scope changes.
- **Do not match existing names**: the tool can create a duplicate parallel policy, such as a second copy of `CA200` with a suffix. That can be worse than an obvious overwrite because it leaves a stale policy quietly participating in sign-in evaluation.

Conditional Access is additive. Policies are evaluated into one combined access decision, and block controls can override what a person expected from a separate allow-style policy. A stale duplicate can silently lock users out, and troubleshooting it later is unpleasant because the tenant now has two policies that look almost the same.

Neither failure mode is a real merge. There is no automatic GUI path that understands three separate versions: the upstream old baseline, the upstream new baseline, and your tenant's local changes. That limitation is inherent when the tenant contains config objects and your file folder contains JSON, but no version-control relationship connects them.

The reliable pattern is to back up, compare, separate new policies from revised policies, and decide what to apply.

## Two Kinds of Upstream Change

Every refresh begins by sorting upstream changes into two buckets.

**Additions** are new policy numbers or new supporting objects that did not exist in your tenant. These are usually safer to import because they do not collide with a locally modified policy. They still need report-only validation, but the decision is clearer: "Do we want to add this new control?"

**Revisions** are changes to an existing policy number. These are not safe to blindly import because that policy may already have tenant-specific modifications. The question is not "Should I import this file?" The question is "Which upstream change should I fold into our local version?"

The upstream changelog shows both patterns. Recent versions added new agent-related policies in the `CA50x` range. The changelog also shows revisions to existing policies, including CA005 moving away from approved-client-app behavior toward app protection, and CA201 being separated into CA201 and CA210 so user risk and sign-in risk are handled separately.

That distinction drives the whole maintenance model:

- New policy number: import cautiously, usually report-only first.
- Existing policy number changed: review the JSON diff and merge by judgment.
- Supporting object changed: inspect dependency impact before importing.
- Local-only policy: keep, remove, or document why it exists.

The fastest first signal is the numbered filename list. Compare the upstream `Config/ConditionalAccess` directory against your tenant export. If upstream now has `CA502`, `CA503`, `CA504`, or `CA505` and your tenant does not, those are additions. If both sides have `CA005`, you are dealing with a revision or local customization, not a simple import.

## Method A: GUI Refresh with IntuneManagement

Use this method when you are maintaining one tenant or when the tenant was originally deployed by GUI and has not yet moved into Git or CIPP.

The safe GUI pattern is:

1. Export the current tenant state.
2. Compare upstream files to the tenant export.
3. Import only the new bucket.
4. Manually review revised policies.
5. Validate in report-only before enforcement changes.

Start with an export. In IntuneManagement, export the current Conditional Access policies, groups, and named locations into a dated folder. This is both your rollback package and your tenant's as-modified truth. Do not skip this step just because the tenant "should" match the last folder you imported. Tenants change.

Next, use **Bulk > Compare** instead of jumping to **Bulk > Import**. IntuneManagement's README confirms the tool supports export, import, documentation, and compare operations. Its migration-table behavior is useful for matching exported dependencies to tenant objects during import, but compare is the safer first move for refresh planning.

Sort the compare result into three buckets:

| Bucket | Meaning | Action |
| --- | --- | --- |
| New in repo | Upstream has a policy or object missing from tenant | Candidate for import in report-only |
| In both | Same policy number exists in both places | Review for upstream revision and local edits |
| Tenant-only | Tenant has something not in upstream | Keep, document, or remove after review |

For the new bucket, import only those policies and required dependencies. Keep Conditional Access state at report-only where supported. Enable dependency handling so groups and named locations resolve to the tenant objects. Match to existing objects where the tool provides that intent, but do not use a broad import as a blanket refresh.

For revised-but-locally-modified policies, slow down. Read the upstream changelog. Inspect the JSON file for that policy. Compare it to the exported tenant policy. Then decide which upstream changes to copy into the live policy. That might mean editing in the Entra admin center, adjusting JSON in your working folder and importing a controlled replacement, or moving the policy into a Git review flow.

There is no clean automated path here. The GUI cannot know whether your added exclusion is a mistake or a contractual client requirement. It cannot know whether a client's service account exception is technical debt or a business-critical integration. You need a human review.

The filename diff remains useful even in a GUI workflow. The baseline's numbered pattern makes it easy to spot new policy numbers. Use that as your "what's new?" scan before opening individual JSON files.

## Method B: Git Refresh Workflow

Git is the recommended upgrade for refresh work because it turns the scary part into a visible diff.

In a Git workflow, your customized policies live in your repository. The upstream baseline is a tracked remote. A refresh becomes normal source-control work:

```bash
git fetch upstream
git checkout client-a
git merge upstream/main
```

If upstream added new files, Git shows them as new files. If upstream changed the same JSON lines you changed locally, Git shows a conflict. That conflict is not a problem; it is the exact place where judgment is required.

A practical MSP pattern is:

- `main` or `baseline` holds your common reviewed baseline.
- `client/example` holds one client's approved deviations.
- `upstream` points to `j0eyv/ConditionalAccessBaseline`.
- Pull requests document why a policy changed.
- Deployment happens from a known commit using IntuneManagement, Microsoft Graph, or automation.

The refresh flow looks like this:

1. Export the current tenant and commit that export if the tenant may have drifted.
2. Fetch upstream.
3. Merge or rebase upstream into your baseline branch.
4. Review new files, modified files, and conflicts.
5. Resolve conflicts per policy number.
6. Open a pull request for review.
7. Deploy the reviewed result in report-only where possible.
8. Tag or record the deployed commit.

This converts a quarterly gamble into a reviewed change. You can see that CA005 changed because Microsoft is retiring a grant behavior, and you can decide whether that matters to a specific client. You can see that CA201 split into CA201 and CA210, and you can decide whether to add the new sign-in risk policy immediately or stage it.

For per-tenant branches, be disciplined. Do not fork every tenant just because you can. Branch when there is a real tenant difference: different allowed countries, different service-provider access, different licensing, different device strategy, or documented risk acceptance. Otherwise, keep clients close to the common baseline so refresh work stays manageable.

Git does not remove the need for validation. It simply makes the decision visible before deployment.

## Method C: CIPP and Drift as the Operating Model

CIPP reframes the maintenance problem. Instead of treating refresh as an occasional manual import, CIPP helps you manage standards and drift across tenants.

CIPP's Template Library currently includes a Conditional Access Framework community repository that points to the j0eyv baseline. The current CIPP source docs distinguish two refresh cadences: tenant-based template libraries sync every 4 hours, while community repository-based template libraries sync every 7 days. The rendered Template Library page also warns that enabling the feature can overwrite templates with the same name.

That overwrite caveat matters. If you customize a synced template in place and CIPP later syncs a template with the same name, your local change can be replaced. Use a naming strategy:

- Keep synced community templates as reference templates.
- Copy templates before client-specific edits.
- Prefix local templates with your MSP or client naming convention.
- Document which templates are source-controlled elsewhere.
- Avoid editing same-name synced templates unless replacement is intentional.

CIPP Standards and Drift Management have different jobs. Standards are good for enforcing specific settings on a schedule. Drift Management is better when you want visibility into how a tenant differs from a desired template, including settings outside the template. Current CIPP docs say Standards reapply or evaluate every 12 hours, and Drift Management evaluates every 12 hours.

The CIPP FAQ also states that each tenant can have only one Drift Management template assigned. Design accordingly. For MSPs, this usually means one drift template per license tier, client segment, or operating model, not a pile of overlapping templates.

A good CIPP refresh model looks like this:

1. Let Template Library update reference templates.
2. Review upstream changes before copying them into operational templates.
3. Assign drift templates to tenant groups, not random individual tenants, where possible.
4. Use Drift Management to identify tenant changes made outside process.
5. Accept intentional deviations with a reason.
6. Deny and remediate unauthorized deviations only after review.

This is the MSP-scale answer to "did someone change a policy in a client tenant?" You are no longer depending on memory or a folder of old exports. You have a system that evaluates alignment and gives you a place to handle exceptions.

## Refresh Checklist

Use this checklist regardless of method:

- **Back up first**: export current Conditional Access policies, groups, and named locations.
- **Read the changelog**: identify new policy numbers and revised existing policies.
- **Diff before apply**: never use import as your first comparison tool.
- **Separate additions from revisions**: additions can be imported cautiously; revisions need manual review.
- **Preserve local intent**: break-glass exclusions, allowed countries, service accounts, and admin scoping are tenant-specific.
- **Use report-only**: any policy touching enforcement should be staged where supported.
- **Validate with What If**: simulate common and risky sign-in scenarios.
- **Verify emergency access**: test break-glass before and after refresh.
- **Watch sign-in logs**: review report-only impact for at least a business week before turning on disruptive controls.
- **Record the version**: note the upstream baseline version, date, and deployed commit or export folder.

This checklist is boring on purpose. Boring is exactly what you want from Conditional Access maintenance.

## Validation and Rollback

Validation starts before enforcement. Use the [Microsoft What If tool](https://learn.microsoft.com/en-us/entra/identity/conditional-access/what-if-tool) to simulate realistic sign-ins. Microsoft notes that What If evaluates enabled and report-only policies, not policies that are off. That makes report-only a useful staging state for validation.

Test at least:

- A normal internal user accessing Office 365.
- An admin accessing Microsoft Admin Portals.
- A break-glass account.
- A guest user.
- A mobile user on iOS or Android.
- A user from an allowed country.
- A user from a blocked or unexpected country.
- An unmanaged Windows or macOS device.
- A service account or automation identity.

Then review sign-in logs and report-only results. Microsoft's report-only guidance explains that report-only policies are evaluated during sign-in and logged without enforcing their controls. Use this to find "would block" outcomes before they become real outages.

Rollback depends on the method:

- **GUI**: restore from the pre-refresh export or manually revert the changed policy objects using the export as reference.
- **Git**: revert the merge commit or redeploy the prior known-good commit.
- **CIPP**: reapply the previous template, remove an unintended template change, or accept a deviation temporarily while you correct the source.

For urgent lockout scenarios, use the emergency access account to disable the offending policy. Then preserve evidence: export the policy set, capture the sign-in log entry, and record what changed. Do not simply toggle random policies until access returns; that creates a second incident inside the first.

## When to Move Up the Ladder

If you are maintaining one tenant, the GUI workflow can be acceptable as long as you are disciplined about export, compare, and report-only validation.

If you maintain the baseline more than once, move to Git. The first merge conflict you resolve in a pull request is cheaper than the first tenant outage caused by duplicate Conditional Access policies.

If you manage many tenants, use CIPP or a similar standards-and-drift model. At MSP scale, the hardest question is not "Can I import a JSON file?" It is "Which tenants differ from the baseline, is that difference intentional, and who approved it?"

## Need Help

If you support Microsoft 365 tenants in Vancouver WA, Portland OR, Seattle WA, or remote client environments, Svetek can help review your Conditional Access baseline, design a Git or CIPP operating model, and safely reconcile upstream changes without losing tenant-specific intent.

For first-time deployment, start with [Deploy a Conditional Access Baseline in Microsoft Entra](/docs/Configuration/Azure/deploy-conditional-access-baseline/).

## References

- [j0eyv ConditionalAccessBaseline](https://github.com/j0eyv/ConditionalAccessBaseline)
- [ConditionalAccessBaseline policy files](https://github.com/j0eyv/ConditionalAccessBaseline/tree/main/Config/ConditionalAccess)
- [Micke-K IntuneManagement](https://github.com/Micke-K/IntuneManagement)
- [CIPP Template Library](https://docs.cipp.app/user-documentation/tools/templatelib)
- [CIPP Standards and Drift](https://docs.cipp.app/user-documentation/tenant/standards/)
- [CIPP Manage Drift](https://docs.cipp.app/user-documentation/tenant/manage/drift)
- [CIPP Standards v Drift FAQ](https://docs.cipp.app/troubleshooting/frequently-asked-questions/standards-v-drift)
- [Microsoft report-only mode guidance](https://learn.microsoft.com/en-us/entra/identity/conditional-access/concept-conditional-access-report-only)
- [Microsoft What If tool](https://learn.microsoft.com/en-us/entra/identity/conditional-access/what-if-tool)
