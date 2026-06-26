# SEO Guidelines for Svetek Documentation

Use this guide when creating or updating pages in this repository. The goal is simple: every page should have a clear search intent, a stable canonical URL, useful search-result copy, and a clean social preview.

## Quick checklist

Before publishing a page, confirm:

- The page answers one specific user need.
- The URL slug is descriptive and stable.
- Front matter includes `title`, `seo_title`, `description`, `keywords`, and `canonical`.
- Open Graph fields are set for important pages: `og_title`, `og_description`, `og_type`, `og_image`, and `og_url`.
- Twitter fields are set when the social preview should differ from Open Graph.
- Images have descriptive alt text and live beside the page when possible.
- Replaced or renamed pages keep redirects.
- The page is linked from `_data/toc.yaml` if it should be discoverable in site navigation.

## Recommended front matter

Use this as the default template for new documentation pages:

```yaml
---
title: "Human-Friendly Page Title"
seo_title: "Primary Keyword Page Title | MSP Guide for Vancouver WA, Portland OR, Seattle WA"
description: "One or two sentences explaining exactly what the page helps the reader do. Include the primary product, service, or problem. Keep this useful, not stuffed."
keywords: "primary keyword, secondary keyword, product name, service area, IT support Vancouver WA, IT support Portland OR, IT support Seattle WA"
canonical: https://help.svetek.com/docs/Category/Product/descriptive-page-slug/
og_title: "Short Social Preview Title"
og_description: "Short social preview description focused on the page's practical value."
og_type: article
og_image: https://help.svetek.com/docs/Category/Product/descriptive-page-slug/images/preview-image.png
og_url: https://help.svetek.com/docs/Category/Product/descriptive-page-slug/
published_time: 2026-06-26T00:00:00+00:00
twitter_title: "Short Social Preview Title"
twitter_description: "Short social preview description focused on the page's practical value."
twitter_image: https://help.svetek.com/docs/Category/Product/descriptive-page-slug/images/preview-image.png
twitter_image_alt: "Plain-language description of the preview image"
redirect_from:
  - /old/path/if-this-page-replaces-one/
layout: docs
---
```

## Field guidance

- `title`: The on-page H1. Make it clear and human-readable.
- `seo_title`: The browser/search title. Include the core topic and, where appropriate, service-area language.
- `description`: Search-result summary. Describe the outcome or task, not just the product.
- `keywords`: Keep a concise comma-separated list. Include product names, task terms, and local service terms when relevant.
- `canonical`: Always set the production URL. Use `https://help.svetek.com/...` and include the trailing slash.
- `og_title` and `og_description`: Social preview copy. Usually shorter than `seo_title` and `description`.
- `og_type`: Use `article` for guides and manuals. Use `website` for section indexes.
- `og_image`: Use an absolute `https://help.svetek.com/...` URL to a relevant image.
- `og_url`: Usually matches `canonical`.
- `published_time`: Use ISO-like timestamps, for example `2026-06-26T00:00:00+00:00`.
- `twitter_*`: Use when the Twitter/X preview should be explicit. If omitted, the shared head template falls back to Open Graph and standard SEO values.
- `redirect_from`: Add old URLs when replacing, renaming, or consolidating pages.

## Titles and descriptions

Good titles are specific:

- Good: `Provisioning M365 Users in 3CX with Entra ID SSO`
- Good: `Configure 3CX IP Phones with Fanvil Auto-Provisioning`
- Avoid: `3CX Setup`
- Avoid: `Microsoft Guide`

Good descriptions explain the job-to-be-done:

- Good: `Step-by-step guide for provisioning Microsoft 365 users into a 3CX PBX configured with Entra ID SSO, including replacement user workflows.`
- Avoid: `This page explains 3CX.`

Keep titles readable. Do not repeat every city or keyword in every field. The `seo_title`, `description`, and `keywords` fields are enough for local-service context when it is relevant.

## URL slugs

Use lowercase descriptive slugs with hyphens:

- Good: `/docs/Configuration/3CX/3cx-m365-user-provisioning-entra-sso/`
- Good: `/docs/Configuration/3CX/configure-3cx-ip-phones-fanvil-provisioning/`
- Avoid: `/docs/Configuration/3CX/new-page/`
- Avoid: `/docs/Guides/Thing/index2/`

When renaming an existing page, keep the old page as a redirect or add `redirect_from` to the new page.

## Page structure

Most guides should follow this shape:

1. Overview: who the guide is for and what it accomplishes.
2. Prerequisites or assumptions.
3. Step-by-step procedure.
4. Verification steps.
5. Common pitfalls or troubleshooting.
6. Need Help section for Svetek support positioning.

Use headings that match what users search for, such as `Configure Presence Sync`, `Assign the Physical Phone`, or `Common Pitfalls`.

## Images

Use images when they clarify a step or improve social previews.

- Store page-specific images in an `images/` folder next to `index.md`.
- Use descriptive filenames, such as `3cx-m365-users-sync.png`.
- Use descriptive Markdown alt text.
- Set `og_image` and `twitter_image` to the best representative screenshot.
- Avoid dark, cropped, or ambiguous preview images when the screenshot should communicate a real UI state.

Example:

```markdown
![3CX M365 Users sync configuration screen](images/3cx-m365-users-sync.png)
```

## Internal links and navigation

Add a page to `_data/toc.yaml` when it should be reachable from the left navigation. Place it under the product or category users would naturally browse.

When a page supersedes another page:

- Point navigation to the new canonical page.
- Keep the old URL as a redirect.
- Add `redirect_from` aliases for likely historical slugs.

## Redirect page template

For an old page that should forward to a new canonical page:

```yaml
---
title: "Old Page Title"
layout: redirect
redirect:
  to: /docs/Configuration/3CX/new-canonical-page/
---
```

## Local SEO notes

Svetek pages can mention Vancouver WA, Portland OR, and Seattle WA when the page is relevant to managed IT, MSP, VoIP, Microsoft 365, security, or support services in those markets.

Use local terms naturally:

- In `seo_title` for important service pages.
- In `description` when service availability matters.
- In the final `Need Help` section.

Do not force city names into every heading or paragraph.

## Pre-publish checks

Run a local build before publishing:

```sh
bundle exec jekyll build --config _config.yml,_config_production.yml
```

If local bundled gems cause Jekyll to crawl `vendor/`, use a temporary verification config:

```sh
printf '%s\n' 'exclude: ["_scripts", "404.html", "index.html", "vendor"]' > /private/tmp/svetek_jekyll_verify.yml
bundle exec jekyll build --config _config.yml,_config_production.yml,/private/tmp/svetek_jekyll_verify.yml
```

Spot-check rendered metadata:

```sh
rg -n '<title>|canonical|og:title|og:description|og:image|twitter:title|twitter:image' _site/path/to/page/index.html
```

## Pull request checklist

Use this checklist in documentation PRs:

- Front matter follows the recommended template.
- Canonical URL matches the final production path.
- Old URLs redirect to the new page.
- Page is linked from `_data/toc.yaml` when appropriate.
- Screenshots render locally and have useful alt text.
- Build passes.
