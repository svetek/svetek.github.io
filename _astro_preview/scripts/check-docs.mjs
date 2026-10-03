import assert from 'node:assert/strict';
import { readFileSync, existsSync, writeFileSync, readdirSync } from 'node:fs';
import { createHash } from 'node:crypto';
import { parse, walkSync, ELEMENT_NODE } from 'ultrahtml';
import { unescape } from 'html-escaper';
import { docs, pages, manifest, textContent, canonicalUrl, localUrl } from '../src/lib/docs.mjs';
import { contactFields, zohoAction } from '../src/lib/contact.mjs';

const dist = new URL('../dist/', import.meta.url);
const read = (path) => readFileSync(new URL(path.replace(/^\//, ''), dist), 'utf8');
const exists = (path) => existsSync(new URL(path.replace(/^\//, ''), dist));
const nodes = (html, predicate) => {
  const matches = [];
  walkSync(typeof html === 'string' ? parse(html) : html, (node) => {
    if (node.type === ELEMENT_NODE && predicate(node)) matches.push(node);
  });
  return matches;
};
const byTag = (html, tag) => nodes(html, (node) => node.name === tag);
const normalize = (value) => value.replace(/\s+/g, ' ').trim();
const failures = [];
const existingIssues = [];
const check = (condition, message) => { if (!condition) failures.push(message); };
const htmlFiles = readdirSync(dist, { recursive: true }).filter((path) => path.endsWith('.html'));
for (const path of htmlFiles) {
  const html = read(path);
  check(nodes(html, (node) => node.name === 'meta' && node.attributes.name === 'robots' && node.attributes.content?.includes('noindex')).length === 1,
    `Missing preview noindex: ${path}`);
  check(!html.includes('googletagmanager.com'), `Analytics enabled: ${path}`);
}
for (const source of manifest.sources) {
  check(exists(`${source.url}index.html`), `Missing source route: ${source.source}`);
}
for (const page of pages) {
  const html = read(`${page.url}index.html`);
  check(nodes(html, (node) => node.name === 'link' && node.attributes.rel === 'canonical')[0]?.attributes.href === (page.data.canonical || canonicalUrl(page.url)), `Canonical mismatch: ${page.url}`);
  const body = nodes(html, (node) => 'data-article-body' in node.attributes)[0];
  check(Boolean(body), `Missing article body: ${page.url}`);
  if (!body) continue;
  check(normalize(textContent(body)) === normalize(textContent(parse(page.html))), `Changed article text: ${page.url}`);
  for (const tag of ['img', 'table', 'pre']) {
    check(byTag(body, tag).length === byTag(page.html, tag).length, `Changed ${tag} count: ${page.url}`);
  }
  const originalIDs = nodes(page.html, (node) => Boolean(node.attributes.id)).map((node) => node.attributes.id);
  const outputIDs = new Set(nodes(body, (node) => Boolean(node.attributes.id)).map((node) => node.attributes.id));
  check(originalIDs.every((id) => outputIDs.has(id)), `Lost anchor: ${page.url}`);
  for (const node of nodes(html, (node) => Boolean(node.attributes.href || node.attributes.src))) {
    const value = unescape(node.attributes.href || node.attributes.src);
    if (/^(https?:|mailto:|tel:|data:|javascript:|edge:)/.test(value)) continue;
    let url;
    try { url = new URL(value, `https://preview.invalid${page.url}`); } catch { continue; }
    if (url.hostname !== 'preview.invalid') continue;
    const target = decodeURIComponent(url.pathname);
    const file = target.endsWith('/') ? `${target}index.html` : exists(target) ? target : `${target}/index.html`;
    let issue;
    if (!exists(file)) issue = `Missing local target ${value}`;
    else if (url.hash && file.endsWith('.html')) {
      const ids = new Set(nodes(read(file), (item) => Boolean(item.attributes.id)).map((item) => item.attributes.id));
      if (!ids.has(decodeURIComponent(url.hash.slice(1)))) issue = `Missing anchor ${value}`;
    }
    if (!issue) continue;
    const isExisting = nodes(page.html, (item) => (item.attributes.href || item.attributes.src) === value).length > 0;
    if (isExisting) existingIssues.push({ page: page.url, issue });
    else failures.push(`${issue} introduced on ${page.url}`);
  }
}
for (const asset of manifest.assets) {
  check(exists(asset.path), `Missing asset: ${asset.path}`);
  if (exists(asset.path)) check(createHash('sha256').update(readFileSync(new URL(asset.path.slice(1), dist))).digest('hex') === asset.sha256, `Changed asset: ${asset.path}`);
}
const rules = read('_redirects');
for (const [from, target] of Object.entries(manifest.redirects)) {
  check(exists(`${localUrl(target)}index.html`), `Broken redirect: ${from}`);
  check(!manifest.redirects[target], `Redirect chain: ${from}`);
  check(rules.includes(`${from} ${target} 301`), `Missing server redirect: ${from}`);
  check(read(`${from}index.html`).includes('http-equiv="refresh"'), `Missing local redirect fallback: ${from}`);
}
const search = JSON.parse(read('docs-search.json'));
check(search.length === docs.filter((page) => page.searchable).length, 'Search index count mismatch');
check(search.every((entry) => exists(`${entry.url}index.html`)), 'Search points to missing page');
const sitemap = read('sitemap.xml');
for (const page of docs.filter((page) => page.searchable)) {
  check(sitemap.includes(canonicalUrl(page.url)), `Missing sitemap URL: ${page.url}`);
}
check(!sitemap.includes('localhost') && !sitemap.includes('/logo/') && !sitemap.includes('/docs/Legal/'), 'Sitemap contains preview or excluded pages');
check(read('_headers').includes('X-Robots-Tag: noindex'), 'Missing preview header');
const edge = read('/docs/Configuration/Intune/edge-notification-scam-remediation/index.html');
check(edge.includes('Need help managing your business devices?'), 'Missing contextual Intune CTA');
const edgeTree = parse(edge);
const mobileDocsNavigation = nodes(edgeTree, (node) => node.name === 'details' && node.attributes.class?.includes('docs-navigation--mobile'))[0];
check(Boolean(mobileDocsNavigation) && !('open' in mobileDocsNavigation.attributes), 'Mobile documentation navigation must start collapsed');
const docsLanding = read('/docs/index.html');
const landingLinks = nodes(docsLanding, (node) => node.name === 'a' && node.attributes.class?.split(' ').includes('docs-card'))
  .map((node) => node.attributes.href);
check(JSON.stringify(landingLinks) === JSON.stringify(['/docs/Guides/', '/docs/Configuration/', '/docs/Service_disclaimers/', '/docs/Templates/']),
  `Documentation landing order or visibility changed: ${landingLinks.join(', ')}`);
const logo = read('/index.html');
check(logo.includes('PRODUCTIVE TEAMS') && logo.includes('PROTECTED BUSINESS') && logo.includes('ROOM TO GROW'), 'Missing hero outcomes');
check(logo.includes('People, process, and technology—working together'), 'Missing approach explanation');
const logoTree = parse(logo);
const mobileMenuLinks = nodes(logoTree, (node) => node.name === 'nav' && node.attributes.class === 'site-mobile-nav')
  .flatMap((node) => nodes(node, (item) => item.name === 'a').map((item) => item.attributes.href));
check(JSON.stringify(mobileMenuLinks) === JSON.stringify(['#services', '#ai-readiness', '#approach', '/docs/']), 'Mobile homepage menu is incomplete');
const contactForm = nodes(read('/contact/index.html'), (node) => node.name === 'form' && 'data-contact-form' in node.attributes)[0];
check(contactForm?.attributes.action === zohoAction && contactForm?.attributes.enctype === 'multipart/form-data', 'Contact form does not post to Zoho');
if (contactForm) {
  const posted = new Set(nodes(contactForm, (node) => ['input', 'select', 'textarea'].includes(node.name)).map((node) => node.attributes.name));
  for (const name of [...contactFields.map((field) => field.name), 'zf_redirect_url']) check(posted.has(name), `Contact form missing Zoho field: ${name}`);
}
check(exists('/contact/thanks/index.html'), 'Missing contact thank-you page');
// Without 404.html, Cloudflare Pages serves the homepage with 200 for unknown paths.
check(exists('/404.html'), 'Missing 404.html: unknown paths would return 200');
for (const path of htmlFiles) check(!read(path).includes('zfrmz.com'), `Hosted Zoho form link still used: ${path}`);
// Only design B ships: no photo hero, no design switcher.
check(!readdirSync(dist, { recursive: true }).some((path) => path.includes('managed-it-hero')), 'Design A hero photo is in the build');
for (const path of htmlFiles) check(!read(path).includes('concept-switch'), `Design switcher still rendered: ${path}`);
check(rules.includes('/logo/ / 301'), 'Missing /logo/ redirect to the homepage');
writeFileSync(new URL('../.generated/parity-report.json', import.meta.url), JSON.stringify({
  sourcePages: manifest.sources.length, renderedArticles: docs.length, routes: pages.length,
  redirects: Object.keys(manifest.redirects).length, assets: manifest.assets.length,
  failures, existingIssues,
}, null, 2));
assert.equal(failures.length, 0, failures.join('\n'));
console.log(`Passed: ${manifest.sources.length} source routes, ${pages.length} pages, ${Object.keys(manifest.redirects).length} redirects, ${manifest.assets.length} unchanged assets, article text, anchors, metadata, search, and preview safety.`);
console.log(`${existingIssues.length} pre-existing content link issues recorded in .generated/parity-report.json; review before production.`);
