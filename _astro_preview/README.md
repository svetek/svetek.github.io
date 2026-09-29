# Svetek Astro Website Preview

This is an isolated preview of the future Svetek marketing site and documentation. It does not replace production, change DNS, or modify the source articles in `../docs/`.

## Local development

Use Node 22.12+ and Ruby 3.3+ (below 4.0). The documentation preview deliberately retains Jekyll/Kramdown as a build-time compatibility bridge, so Liquid, tables, code, and existing heading IDs are not rewritten during the layout review. Astro owns the page layouts and routes; no Ruby runs in the browser or on the static host.

From the repository root, install the existing preview bundle with `BUNDLE_GEMFILE=gemfiles/cloudflare.gemfile bundle install`. Then, in this directory:

```sh
npm ci
npm run dev -- --background
```

Use `npm exec astro dev status`, `npm exec astro dev logs`, and `npm exec astro dev stop` to manage the development server. If Homebrew Ruby/Node are not first on PATH on this Mac, prepend `/opt/homebrew/opt/ruby@3.3/bin:/opt/homebrew/opt/node@22/bin`.

## Production build

```sh
npm run build
npm run check:docs
npm run preview
```

The generated static site is written to `dist/`. Build and development startup freshly export documentation from the repository, not a previous `_site` build. After editing a source article while the development server is running, run `npm run prepare:docs` to refresh the export.

## Current scope

Compare the photography concept at `/` with the image-free animated logo concept at `/logo/`. Both use the vehicle tagline. The logo concept uses brighter yellow and orange with charcoal, with the outcomes “Productive teams,” “Protected business,” and “Room to grow” surrounding the mark. People, process, and technology explain the approach farther down the page. The comparison navigation is for this prototype only. Headline and logo entrances run automatically once as each comes into view; the three dots move independently and settle within five seconds. Reduced-motion preferences show the finished composition without animation. No interaction is required, and the content remains visible without JavaScript.

- Marketing homepage design
- Responsive navigation and hero
- Four core service areas
- AI readiness section
- Consultation and contextual documentation calls to action
- Documentation landing at `/docs/`, topic indexes, breadcrumbs, navigation, and on-page contents
- Existing documentation paths, article bodies, images, attachments, and metadata
- Full-text client-side search at `/search/?q=...`, with a no-JavaScript article listing
- Existing redirect routes with local HTML fallbacks and Cloudflare `_redirects` 301 rules
- Curated documentation grouping and order from `_data/toc.yaml`; Legal and Standards remain routable but are not promoted on the public landing page
- Responsive homepage navigation and collapsed-on-phone article navigation

## Documentation and SEO safeguards

`npm run check:docs` verifies source-route coverage, article text, heading anchors, table/code/image counts, asset hashes, canonicals, sitemap/search membership, redirect targets, internal links added by the new layout, and preview noindex. The report in `.generated/parity-report.json` also lists pre-existing content link problems separately; passing the migration checks is not a claim that the old content has no issues.

All preview pages and the generated `_headers` remain `noindex`. Robots.txt permits crawling so search engines can see that directive. Existing documentation canonical and social URLs still point to `help.svetek.com`; the sitemap is an inventory of existing public article URLs, not a sitemap to submit for this preview. No analytics run here. New preview-only section pages also remain unindexed. Legal pages stay out of search and the sitemap.

The old Bootstrap tabbed articles display all panels, with their tab links acting as anchors; no instructions are hidden behind a removed JavaScript dependency. The article source remains unchanged.

Generated `.generated/`, `public/docs/`, `public/images/`, and `public/favicons/` are build-owned and ignored by Git. Do not edit those copies. Edit the original articles or assets in the repository.

## Still required before production

- Review every article visually and resolve the existing content-link audit findings.
- Decide whether to retain the build-time Jekyll bridge for the first release or replace it after parser/anchor parity is independently verified.
- Complete the WordPress service/page/post/media migration, form verification, analytics, and deployment workflow.
- Capture Search Console baselines and verify the host properties; current search performance has not been audited here.
- Choose the production homepage, remove comparison UI, and align production canonicals, social URLs, schema, internal links, sitemap, and indexing settings in one release.
- Configure and test one-hop server-side hostname redirects, mapping the old documentation homepage to `/docs/` and merging renamed-path redirects without chains. Keep the old host and TLS active.
- Add production verification for HTTP status codes, a real 404, responsive/accessibility checks, and a rollback path.

No production deployment, indexing switch, domain migration, or Git push is performed by these preview commands.

## Automation

`.github/workflows/astro-preview.yml` installs Ruby and Node, builds the Astro preview, runs the documentation parity checks, and uploads the static artifact on pull requests and manual runs. It does not deploy the artifact. The existing Jekyll preview workflow remains separate while its live-site-affecting changes are reviewed independently.
