# Consolidating Svetek marketing and documentation

Status: review and preview only. The live site still uses GitHub Pages from `main` with `help.svetek.com`. WordPress, DNS, and hostname redirects have not been changed.

## Recommendation

The new site lives in its own repository, [svetek/svetek-astro](https://github.com/svetek/svetek-astro): the approved Astro logo design (B) plus the documentation, rendered by Astro with no Jekyll or Ruby dependency and built by Cloudflare Pages. Until cutover, articles are still edited here and imported with `npm run import:jekyll` in that repository; its README describes the import, the frozen Jekyll baseline, and the parity checks. Production is unchanged. The Jekyll-only starter described below is retained as earlier migration work, not the current chosen presentation layer.

One repository is an operating choice, not a Google ranking factor. A move can improve navigation, consistency, and maintenance, but it does not guarantee rankings or leads. Compare technical-documentation traffic separately from service-page enquiries, calls, and qualified leads. Export Search Console and analytics baselines for both hosts before judging either site's value; the claim that documentation supplies all useful traffic has not been verified.

The bridge intentionally separates a layout change from a Markdown-engine change. Removing Ruby can follow once parser and anchor parity are verified; it is not a prerequisite for reviewing the combined site.

## What the review found

| Proposal | Verified correction |
| --- | --- |
| Jekyll 3.9 from `github-pages` 198 | `bundle exec jekyll -v` reports **3.8.5**. The lockfile agrees. `.ruby-version` says 2.3.6; the system Ruby used locally was 2.6.10. The preview uses Ruby 3.3 and Jekyll 4.4. |
| Cloudflare is the builder | GitHub's Pages API reports `build_type: legacy`, source `main` at `/`, custom domain `help.svetek.com`. A Cloudflare proxy does not replace that builder. |
| Three plugins make this a Gemfile-only upgrade | Those plugins are a small part of the migration. Kramdown, Liquid rendering, Sass, deployment exclusions, generated search data, and redirects also need validation. The old Sass imports produce deprecation warnings on the modern compiler. |
| Jekyll 4 unlocks incremental builds | Jekyll 3 already has incremental builds, and this repo enabled them. Incremental regeneration has incomplete dependency tracking. Use clean full builds for releases and cache dependencies instead. |
| Zero docs URLs change | The paths remain the same. `https://help.svetek.com/docs/.../` becomes `https://svetek.com/docs/.../`, which is a hostname migration. |
| Change `url:` once to update all metadata | The shared head, redirect layout, robots.txt, page canonical/OG/image fields, and article links contain explicit hostnames. Changing `url:` alone is insufficient. The starter makes the shared head respect `site.url`, but the remaining explicit values still need an audited conversion at cutover. |
| Posts use `/blog/<slug>/` | The public post sitemap lists a `/blog/` archive and **12 root-level article URLs**. Preserve explicit per-post permalinks. |
| Byte-identical output after upgrade | Compare URL inventory, article text, links, images, metadata, redirects, and visual rendering. Generated timestamps and parser/compiler changes make exact byte equality a poor release gate. |

## Blog decision

Do not add a new posting schedule merely for SEO. First retain or deliberately map the 12 existing posts and `/blog/` archive. Review Search Console, inbound links, usefulness, and accuracy before retiring any. A blog archive can remain without ongoing publishing.

Prioritize service pages, real examples of work, useful local information, and direct paths to contact. If there is a sustained supply of original business-facing material later, Jekyll posts can host it without another platform migration. Keep technical procedures in `/docs/`.

## Starter delivered

- `.github/workflows/cloudflare-preview.yml`: pull requests build an artifact. A manual run optionally uploads it to a dedicated Cloudflare Pages preview project.
- `gemfiles/cloudflare.gemfile` and lockfile: independent modern dependency set. The root Gemfile remains intact while GitHub Pages still serves production.
- `_config_cloudflare_preview.yml`: full preview builds, analytics disabled, noindex enabled, preview-only pages included, development files excluded.
- `_layouts/marketing.html`, `css/marketing.scss`, and `_preview/marketing.md`: branded starter at `/marketing-preview/`. Its commercial links point to existing public pages until their replacements exist.
- `_includes/cta-msp.html` and `_data/msp.yml`: reusable CTA with product-specific copy, a relevant service link, Discovery form, telephone, and existing-client portal. Optional `cta_title` and `cta_description` page fields override the copy. The CTA invites prospects to discuss scope and request pricing; it does not publish or imply a fixed service price.
- `_scripts/check-migration-preview.rb`: checks every documentation index file and image, navigation links, search JSON, core metadata, CTA placement, and preview noindex.
- `_migration/wordpress-url-inventory.csv`: initial sitemap-derived inventory, dated 2026-09-24. It is a starting list, not proof there are no other URLs.

The marketing sample does not replace the current docs homepage. At the eventual layout cutover, create `/docs/index.md` with the existing landing layout, change the root `index.md` to marketing, and update docs logos, Home links, breadcrumbs, and search links to the intended destinations.

## Local preview

Use Ruby 3.3 or later supported by the preview Gemfile. On this Mac, Ruby 3.3 was installed alongside system Ruby; it did not replace the legacy bundle.

```sh
export PATH="/opt/homebrew/opt/ruby@3.3/bin:$PATH"
export BUNDLE_GEMFILE=gemfiles/cloudflare.gemfile
bundle install
JEKYLL_ENV=production bundle exec jekyll build --config _config.yml,_config_production.yml,_config_cloudflare_preview.yml --destination _site_preview
bundle exec ruby _scripts/check-migration-preview.rb _site_preview
python3 -m http.server 4001 --bind 127.0.0.1 --directory _site_preview
```

Open `http://127.0.0.1:4001/marketing-preview/`. The root still previews the docs home. The preview's noindex and analytics settings are for staging only.

Homebrew may put its Ruby and Bundler first on your PATH. To reproduce the legacy build on this Mac, use `JEKYLL_ENV=production /usr/bin/ruby /usr/bin/bundle exec jekyll build --config _config.yml,_config_production.yml` with `BUNDLE_GEMFILE` unset. Neither the root dependency lockfile nor system Ruby was replaced.

## Cloudflare preview setup

1. Create a **dedicated Direct Upload Pages project**, production branch `main`, with no custom domains. Choose the project type deliberately; Direct Upload and Git-integrated projects have different setup paths.
2. Create an API token with **Account > Cloudflare Pages > Edit**, limited to the intended account. Keep it in GitHub secrets, never in this repo or Jekyll data.
3. Create the GitHub Actions environment `cloudflare-preview`. Add secrets `CLOUDFLARE_ACCOUNT_ID` and `CLOUDFLARE_API_TOKEN`; add variable `CLOUDFLARE_PAGES_PROJECT` with the project name.
4. Once the workflow exists on the default branch, run **Build Jekyll 4 migration preview**. With `deploy_preview` off it only builds an artifact. Enable it to upload to branch `migration-preview`.
5. The workflow checks that the target's production branch is `main` and that it has no custom domains before uploading. It does not update DNS, add domains, or replace production.
6. Open the resulting preview URL and verify the `X-Robots-Tag: noindex` response. Cloudflare Access can restrict preview access if wanted. Noindex prevents indexing; it is not access control.

The `_headers` file and HTML robots tags explicitly mark this entire build noindex. Robots.txt allows crawling so crawlers can see those directives. Do not reuse this config or artifact for production. The stub 404 is a real 404 page for Pages; do not keep the legacy homepage-redirecting 404 during the final move.

## Corrected cutover sequence

1. **Inventory and baseline.** Export WordPress content and media, sitemaps, Search Console pages/queries, key backlinks, form behavior, tracking, and any existing redirects. Include `/wp-content/uploads/` assets, privacy pages, callback/thank-you pages, verification files, and both `www` and apex host behavior. Keep a WordPress backup and a tested rollback route.
2. **Validate Jekyll 4 in preview.** Compare it with the current build. Confirm all article URLs, images, tables, code blocks, search entries, dark/mobile layout, and metadata. Keep full release builds. After hosting is switched, replace the legacy root Gemfile/lockfile and `.ruby-version` with the validated toolchain, and remove the transitional second bundle.
3. **Build the complete replacement.** Marketing home at `/`, docs landing at `/docs/`, unchanged docs article paths, existing service/location/contact URLs, and preserved posts. Create `_layouts/post.html` only when importing retained posts. The preview starter is not a full WordPress replacement.
4. **Forms and tracking.** Initially reuse the existing hosted Zoho Discovery form and public contact routes. Verify submissions and confirmation behavior end to end. A custom Pages Function is optional, not a requirement for a static site. If built later, validate Turnstile server-side before sending anything, handle failures, and keep API keys out of static output. Preserve approved SMS consent wording and record the exact consent text/version and user action with an appropriate timestamp; settle any additional collection and retention requirements with the approved policy rather than assuming an IP address proves compliance.
5. **Prepare a production artifact.** Use `url: https://svetek.com`, `baseurl: ""`, remove preview noindex/headers, use the correct analytics settings, generate a production robots.txt/sitemap, and convert hard-coded old-host canonicals, OG URLs, structured data, redirects, assets, and owned internal links. Explicitly exclude all preview and migration files. Verify the target pages resolve correctly before redirecting users to them.
6. **Switch deliberately.** Attach `svetek.com` to the Pages project and follow its custom-domain/DNS setup. Keep mail records intact. Once the new origin is healthy, enable the old-host redirects and the corresponding metadata together. Avoid redirect loops and multiple-hop chains. Test representative articles, the old docs home, query strings, images, unknown paths, and all lead forms.
7. **Monitor and roll back if needed.** Verify both hosts in Search Console; submit the new sitemap and use Change of Address when applicable. Monitor crawl errors, indexing, old/new traffic, leads, and email delivery. Keep WordPress staging private/noindex and keep the old subdomain resolving with a valid certificate for redirects. Retain redirects indefinitely where practical; Google recommends at least a year.

There is no required four-to-six-week wait. If marketing is moved first to isolate infrastructure changes, keep docs on the old host and explicitly define how any apex docs copies are handled during that phase. Do not leave duplicate hosts with conflicting canonicals by accident. Reassess the next cutover using observed errors and readiness, not a fixed calendar delay.

## Hostname redirects

Use Cloudflare server-side permanent redirects. Configure the more specific homepage rule first, and preserve query strings on both:

| Match | Destination | Status |
| --- | --- | --- |
| `http.host eq "help.svetek.com" and http.request.uri.path eq "/"` | `https://svetek.com/docs/` | 301 |
| `http.host eq "help.svetek.com"` | `concat("https://svetek.com", http.request.uri.path)` | 301 |

Handle `www.svetek.com` consistently as a separate rule if it is an alias. The root exception matters: the old documentation homepage maps to the new docs landing, not the marketing homepage. Keep `/search/`, image paths, and other existing non-doc-prefix resources working at the destination.

For renamed paths, prefer Cloudflare Pages `_redirects` or Redirect Rules where available. `jekyll-redirect-from` and this repo's redirect layout generate client-side redirect pages; they cannot send HTTP 301 responses. Build an explicit map of existing redirect stubs so a moved hostname plus moved path can resolve in one hop.

## WordPress import

Use WXR as source material, not a promise of a finished migration. Run imports outside the live source tree and review the results. The WordPress.com importer accepts an XML export but does not preserve every SEO/custom field. Inventory Elementor/shortcode markup, media, page hierarchy, metadata, forms, and redirects separately.

Assign the original URL explicitly to each retained post, for example `permalink: /mastering-digital-privacy/`. Do not apply `/blog/:title/` globally to this site's old posts. Keep useful old image URLs or provide their own redirects; sitemap images currently reference `dev.svetek.com`, so retiring WordPress without an asset audit risks broken images.

## References

- [Google: site moves with URL changes](https://developers.google.com/search/docs/crawling-indexing/site-move-with-url-changes)
- [Jekyll: upgrading from 3 to 4](https://jekyllrb.com/docs/upgrading/3-to-4/)
- [Jekyll: incremental regeneration limitations](https://jekyllrb.com/docs/configuration/incremental-regeneration/)
- [Cloudflare Pages: Direct Upload with CI](https://developers.cloudflare.com/pages/how-to/use-direct-upload-with-continuous-integration/)
- [Cloudflare Pages: preview deployments](https://developers.cloudflare.com/pages/configuration/preview-deployments/)
- [Cloudflare Turnstile: server-side validation](https://developers.cloudflare.com/turnstile/get-started/server-side-validation/)
- [Jekyll Import: WordPress XML importer](https://import.jekyllrb.com/docs/wordpressdotcom/)
- [WordPress post sitemap](https://svetek.com/post-sitemap.xml), [page sitemap](https://svetek.com/page-sitemap.xml), [service sitemap](https://svetek.com/service-sitemap.xml)
