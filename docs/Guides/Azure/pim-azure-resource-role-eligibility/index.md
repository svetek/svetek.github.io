---
title: "Part 2: Assign Eligible Azure Resource Roles with PIM"
seo_title: "Assign Eligible Azure Resource Roles with PIM | MSP Azure Admin Guide"
description: "Step-by-step guide for assigning eligible Azure resource roles with Microsoft Entra Privileged Identity Management, including scope, member selection, eligibility settings, and verification."
keywords: "Azure PIM eligible role assignment, Microsoft Entra Privileged Identity Management, Azure resource roles PIM, assign eligible Contributor role, Azure subscription IAM, MSP Azure administration, IT support Vancouver WA, IT support Portland OR, IT support Seattle WA"
canonical: https://help.svetek.com/docs/Guides/Azure/pim-azure-resource-role-eligibility/
og_title: "Assign Eligible Azure Resource Roles with PIM"
og_description: "Configure eligible Azure resource role assignments with Microsoft Entra Privileged Identity Management."
og_type: article
og_image: https://help.svetek.com/images/logo_horizontal_whitetext.svg
og_url: https://help.svetek.com/docs/Guides/Azure/pim-azure-resource-role-eligibility/
published_time: 2026-07-22T00:00:00+00:00
date: 2026-07-22
tags:
  - Microsoft Entra
  - Azure
  - PIM
  - Privileged Access
twitter_title: "Assign Eligible Azure Resource Roles with PIM"
twitter_description: "Create eligible Azure resource role assignments with PIM instead of standing admin access."
twitter_image: https://help.svetek.com/images/logo_horizontal_whitetext.svg
twitter_image_alt: "Svetek logo"
redirect_from:
  - /docs/Guides/Azure/PIM_Eligibility_Setup/
layout: docs
---

Use this guide to assign an **eligible** Azure resource role through Microsoft Entra Privileged Identity Management (PIM). Eligible assignments let an administrator or support group activate a role only when needed instead of holding standing access all the time.

This article is Part 2 of the PIM series. Part 1 covers how a user activates eligible PIM group membership or ownership: [Privileged Identity Management (PIM)](/docs/Guides/Azure/PIM/).

The example role in this guide is **Contributor**, but the same workflow applies to other Azure resource roles when the scope and business need are approved.

Source links were checked on **July 22, 2026**. Microsoft Entra and Azure portal navigation changes over time, so confirm the linked Microsoft Learn articles when using this procedure in a production tenant.

## Prerequisites

Before assigning eligibility, confirm:

- The tenant has licensing that supports Privileged Identity Management.
- You have permission to manage PIM for the selected Azure resource scope.
- The target user or group already exists in Microsoft Entra ID.
- The Azure scope is known: management group, subscription, resource group, or resource.
- The requested role and duration are approved in the ticket.
- Emergency access and owner coverage are documented before changing privileged access.

Use the narrowest scope that can support the work. Prefer resource group scope over subscription scope when the technician only needs access to one workload.

## Choose the Azure Scope

1. Sign in to the [Azure portal](https://portal.azure.com/).
2. Open the target **subscription**, **resource group**, or **resource**.
3. Select **Access control (IAM)**.
4. Confirm you are viewing the correct scope before adding any assignment.

The scope determines where the role applies. A Contributor assignment at subscription scope is much broader than Contributor at a resource group scope.

## Add a Role Assignment

1. In **Access control (IAM)**, select **Add**.
2. Select **Add role assignment**.
3. Open the **Privileged administrator roles** tab when available.
4. Search for the approved role, such as **Contributor**.
5. Select the role.
6. Select **Next**.

If the role does not appear as a privileged administrator role, stop and verify that PIM is available for the selected scope and that you have the right permissions to manage role assignments there.

## Select Members

1. Open the **Members** tab.
2. Choose **User, group, or service principal**.
3. Select **Select members**.
4. Search for the approved user or group.
5. Select the member.
6. Select **Select**.
7. Confirm the selected member matches the ticket.

For MSP operations, assign eligibility to an approved support group when that group has controlled membership and review history. Avoid assigning broad production roles directly to shared or generic accounts.

## Set Eligibility

1. Continue to the assignment settings.
2. Select **Eligible** instead of **Active**.
3. Choose the approved start date.
4. Choose the approved end date or maximum duration allowed by policy.
5. Add any required justification.
6. Select **Review + assign**.
7. Review the role, scope, member, assignment type, and duration.
8. Select **Assign**.

Eligible is the preferred option for privileged operational roles because the user must activate the role when needed. Active assignments should be reserved for documented exceptions.

## Verify the Assignment

After creating the eligible assignment:

1. Return to the selected Azure scope.
2. Open **Access control (IAM)**.
3. Review role assignments for the user or group.
4. Open **Privileged Identity Management**.
5. Review **Azure resources** and confirm the assignment appears as eligible.
6. Ask the assigned user to open **My roles** in PIM and confirm they can see the eligible Azure resource role.

Do not assume the assignment is correct until the target user or group can see it from the activation side.

## Activation Notes for Users

When the user needs the role, they should:

1. Open [Microsoft Entra admin center](https://entra.microsoft.com/).
2. Go to **Identity Governance** > **Privileged Identity Management** > **My roles**.
3. Select **Azure resources**.
4. Find the eligible role.
5. Select **Activate**.
6. Complete MFA, scope, duration, approval, and justification prompts required by policy.

For user activation instructions, Microsoft maintains a separate guide for activating Azure resource roles in PIM.

## Common Pitfalls

- **Wrong scope**: subscription-level Contributor is much broader than most support tasks require.
- **Active instead of eligible**: active assignments create standing access and should be justified.
- **Direct user assignment when a group is better**: group eligibility is easier to review when group ownership is disciplined.
- **Group sprawl**: assigning eligibility to a poorly governed group weakens the value of PIM.
- **No end date**: long-lived eligibility should match the client's access review process.
- **No verification**: always confirm the assigned person can see the eligible role in PIM.

## Documentation Checklist

Record the following in the ticket:

- Azure scope.
- Role assigned.
- User or group assigned.
- Eligible or active assignment type.
- Start and end date.
- Business reason.
- Approver.
- Verification result.

If this is part of onboarding, record the assignment in the client's privileged access documentation and include it in future access reviews.

## References

- [Microsoft Learn: Assign Azure resource roles in Privileged Identity Management](https://learn.microsoft.com/en-us/azure/active-directory/privileged-identity-management/pim-resource-roles-assign-roles)
- [Microsoft Learn: Activate Azure resource roles in Privileged Identity Management](https://learn.microsoft.com/en-us/entra/id-governance/privileged-identity-management/pim-resource-roles-activate-your-roles)
- [Microsoft Learn: Start using Privileged Identity Management](https://learn.microsoft.com/en-us/entra/id-governance/privileged-identity-management/pim-getting-started)
- [Microsoft Learn: Privileged Identity Management documentation](https://learn.microsoft.com/en-us/entra/id-governance/privileged-identity-management/)

## Need Help

For Azure and Microsoft 365 environments in Vancouver WA, Portland OR, Seattle WA, and remote client environments, Svetek can help review privileged Azure access, configure PIM eligibility, validate activation workflows, and document administrative access safely.

