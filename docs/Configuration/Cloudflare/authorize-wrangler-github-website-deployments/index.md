---
title: "Authorize Wrangler for GitHub Website Deployments"
seo_title: "Authorize Cloudflare Wrangler for GitHub Website Deployments | MSP Guide"
description: "Technician procedure to review existing Cloudflare access, grant least-privilege Wrangler permissions, and configure GitHub Actions to deploy or configure a Cloudflare-hosted website."
keywords: "Cloudflare Wrangler GitHub Actions, Cloudflare API token GitHub deployment, Wrangler permissions, Cloudflare Workers Editor, Cloudflare Pages Write, Cloudflare Connected Applications"
canonical: https://help.svetek.com/docs/Configuration/Cloudflare/authorize-wrangler-github-website-deployments/
og_title: "Authorize Wrangler for GitHub Website Deployments"
og_description: "Review Cloudflare access and use a least-privilege API token for Wrangler deployments from GitHub Actions."
og_type: article
og_image: https://help.svetek.com/images/logo_horizontal_whitetext.svg
og_url: https://help.svetek.com/docs/Configuration/Cloudflare/authorize-wrangler-github-website-deployments/
published_time: 2026-09-24T00:00:00+00:00
date: 2026-09-24
tags:
  - Cloudflare
  - Wrangler
  - GitHub Actions
  - CI/CD
  - Website Deployment
twitter_title: "Authorize Wrangler for GitHub Deployments"
twitter_description: "Use least-privilege Cloudflare credentials for Wrangler deployments from GitHub Actions."
twitter_image: https://help.svetek.com/images/logo_horizontal_whitetext.svg
twitter_image_alt: "Svetek logo"
layout: docs
---

Use this procedure when a GitHub repository uses [Cloudflare Wrangler](https://developers.cloudflare.com/workers/wrangler/) to deploy or configure a Cloudflare-hosted website, Worker, Pages project, route, or custom domain.

The deployment identity must be separate from a technician's interactive Cloudflare login. Use a scoped **account API token** for GitHub Actions. Use `wrangler login` only for a person working interactively on a trusted workstation.

## Understand the two authorization paths

| Use case | Authentication method | Where access comes from |
| --- | --- | --- |
| Technician runs Wrangler locally | `wrangler login` OAuth flow | The technician's Cloudflare member permissions and the OAuth authorization they approve. |
| GitHub Actions runs Wrangler | Account API token in GitHub Actions secrets | The token's explicit roles and resource scope. |

Do **not** run `wrangler login` in GitHub Actions. CI/CD is non-interactive, and Cloudflare documents API tokens as the required authentication method for Wrangler in GitHub Actions.

The interactive OAuth authorization shown by Wrangler is not a replacement for a CI/CD token. Cloudflare currently does not support granular authorization in the `wrangler login` OAuth flow; use an account API token when the work must be limited to specific Cloudflare resources.

## Review existing Cloudflare access first

Review access before granting or creating anything new. This prevents duplicate credentials, overly broad roles, and forgotten OAuth authorizations.

### 1. Review account-member permissions

1. Sign in to the [Cloudflare dashboard](https://dash.cloudflare.com/) and select the intended account.
2. Go to **Manage Account** > **Members**.
3. Find the person who will administer the deployment and open their member record.
4. Review each directly assigned policy, including its **role** and **scope**. Confirm that it applies only to the required account, domain, product, or resource.
5. Open the **Groups** view and review any User Groups to which the person belongs. Cloudflare's Members page shows direct policies only; effective access also includes policies inherited through User Groups.

For a person who needs to deploy an existing Worker, grant **Workers Editor** at the smallest available scope. Do not assign an account-wide administrator role merely to run Wrangler.

### 2. Review connected OAuth applications

Interactive Wrangler authorization creates an OAuth authorization for the signed-in user.

1. In the Cloudflare dashboard, open your profile.
2. Go to **Access Management** > **Connected Applications**.
3. Find **Wrangler** and any other deployment-related application.
4. Review the authorized account selection and permissions.
5. Revoke applications that are no longer needed. Reauthorization is required before a revoked application can access Cloudflare again.

When approving a new Wrangler OAuth request, verify that the application is owned and managed by Cloudflare, choose only the intended account, review required permissions, and decline optional permissions that are not needed.

### 3. Review API tokens

API token secrets cannot be displayed after creation. You can still review each token's name, status, permissions, resource scope, and last-used information.

1. For user-owned tokens, open **My Profile** > **API Tokens**.
2. For account-owned automation tokens, select the intended account and open **Manage Account** > **API Tokens**.
3. Identify tokens used by deployment automation, scripts, or GitHub.
4. Confirm each token has an owner, a documented purpose, the smallest applicable scope, and a rotation or retirement plan.
5. Revoke or rotate unused, duplicate, exposed, or over-privileged tokens. Update GitHub secrets immediately after rotation.

### 4. Review the GitHub repository

In the repository, inspect the following without revealing secret values:

- `.github/workflows/` for Wrangler or Cloudflare deployment workflows;
- **Settings** > **Secrets and variables** > **Actions** for the names and environment scope of deployment secrets;
- `wrangler.jsonc`, `wrangler.toml`, or equivalent project configuration for the account ID, Worker/Pages project, routes, custom domains, and bindings; and
- branch and environment protections that control which workflow runs can deploy.

Do not store an API token in repository files, workflow YAML, issue comments, or documentation. Do not print environment variables in GitHub Actions logs.

## Select the minimum Cloudflare permissions

Choose permissions based on what the workflow actually changes. Start with the narrowest scope and add only the capability that a documented deployment error proves is required.

| Deployment action | Minimum access |
| --- | --- |
| Deploy an existing Worker without changing routes or custom domains | **Workers Editor** scoped to that Worker, or the Workers product if per-Worker scope is not available. |
| Create a new Worker | **Workers Admin** at the Workers product scope. Restrict or rotate this higher-privilege token after initial creation if possible. |
| Change a Worker route or custom domain | **Workers Editor** plus **Zone > Workers Routes > Write** for each affected zone. |
| Deploy or configure a Cloudflare Pages project | **Pages Write** with the smallest available account scope. |
| Modify DNS records as part of deployment | **Zone > DNS > Edit** for each affected zone, only when the workflow actually changes DNS. |
| Use a bound resource directly, such as listing KV data or querying D1 | Add only the specific product permission required for that direct action. A normal Worker deployment does not need separate permission merely because it contains a binding. |

Do not use global API keys. Do not give a deployment token billing, member-management, or account-administration access.

## Create an account API token for GitHub Actions

An account API token is preferred for GitHub automation because it is not tied to a technician's personal Cloudflare login.

1. In Cloudflare, select the intended account and go to **Manage Account** > **API Tokens**.
2. Select **Create Token**.
3. Start with the **Edit Cloudflare Workers** template for a Worker deployment, or choose a custom token for Pages or another website configuration.
4. Give the token a purpose-based name that identifies the repository or deployment role without embedding credentials or internal naming conventions.
5. Configure only the permissions from the table above.
6. Restrict the token to the intended account and, where supported, to the relevant Worker or zone. Avoid **All accounts** and **All zones** unless the deployment genuinely requires them.
7. Create the token and copy its value once into the approved secret-management workflow. Treat it as a credential; Cloudflare will not show the full value again.

If a deployment needs both account-level Workers access and zone-level route access, include both permission policies in the same token only when they are required for the same workflow. Scope the zone permission to the specific affected zone.

## Store credentials in GitHub Actions secrets

1. In GitHub, open the repository and go to **Settings** > **Secrets and variables** > **Actions**.
2. Add a repository or protected environment secret named `CLOUDFLARE_API_TOKEN` with the account API token value.
3. Add `CLOUDFLARE_ACCOUNT_ID` with the intended Cloudflare account ID. Although an account ID is not a secret by itself, storing it with the deployment credentials avoids accidental cross-account use.
4. Limit environment-secret access to the protected deployment branch or environment. Require review for production deployments where the repository workflow supports it.

Never commit the token to the repository. If a token is exposed in a commit, log, ticket, or chat, revoke it immediately and create a replacement.

## Configure the GitHub Actions workflow

Use the official Wrangler action or run Wrangler directly with the two GitHub secrets. This minimal example deploys the project configured in the repository:

```yaml
name: Deploy Cloudflare website

on:
  push:
    branches:
      - main

permissions:
  contents: read

jobs:
  deploy:
    runs-on: ubuntu-latest
    timeout-minutes: 60
    steps:
      - uses: actions/checkout@v6
      - name: Deploy with Wrangler
        uses: cloudflare/wrangler-action@v4
        with:
          apiToken: ${{ secrets.CLOUDFLARE_API_TOKEN }}
          accountId: ${{ secrets.CLOUDFLARE_ACCOUNT_ID }}
```

Keep the workflow's deployment trigger limited to protected branches or approved environments. Pull-request workflows should build and test without using production deployment secrets unless there is a deliberate preview-environment design.

## Validate the deployment

1. Start with a staging project, preview environment, or controlled deployment branch when available.
2. Run the GitHub Actions workflow and confirm the job completes without exposing credentials in logs.
3. In Cloudflare, verify the expected Worker or Pages deployment, route, custom domain, and website behavior.
4. Confirm the token has only the permissions required by the successful deployment. Remove any temporary or exploratory permissions.
5. Recheck **Manage Account** > **API Tokens**, **Manage Account** > **Members**, and **Profile** > **Access Management** > **Connected Applications** after the rollout.

## Troubleshooting

| Symptom | Likely cause | Corrective action |
| --- | --- | --- |
| GitHub workflow asks for login or fails authentication | `wrangler login` was assumed for CI/CD, the token secret is missing, or the account ID is wrong | Use an account API token in `CLOUDFLARE_API_TOKEN` and verify `CLOUDFLARE_ACCOUNT_ID`. |
| Deployment can update a Worker but cannot change a route or custom domain | The token lacks zone-level route permission | Add **Zone > Workers Routes > Write** only for the affected zone. |
| Deployment cannot create a Worker | The token has Editor rather than product-level Admin access | Use a controlled, temporary Workers Admin token to create the Worker, then reduce access when practical. |
| Local Wrangler login has more access than expected | The member inherits permissions through a User Group or an existing OAuth authorization | Review both **Members** and **Groups**, then review Connected Applications. |
| Existing token cannot be recovered | Cloudflare does not redisplay token secrets | Create a replacement token, update the GitHub secret, validate the workflow, then revoke the old token. |

## References

- [Cloudflare: GitHub Actions with Wrangler](https://developers.cloudflare.com/workers/ci-cd/external-cicd/github-actions/)
- [Cloudflare: Workers roles and permissions](https://developers.cloudflare.com/workers/authorization/workers/)
- [Cloudflare: OAuth application authorization and revocation](https://developers.cloudflare.com/fundamentals/oauth/authorizing-an-application/)
- [Cloudflare: Manage account members](https://developers.cloudflare.com/fundamentals/manage-members/manage/)
- [Cloudflare: Create an API token](https://developers.cloudflare.com/fundamentals/api/get-started/create-token/)
- [Cloudflare: Agent setup](https://developers.cloudflare.com/agent-setup/)
