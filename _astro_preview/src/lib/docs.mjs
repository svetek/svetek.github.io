import exportedDocs from '../../.generated/docs.json' with { type: 'json' };
import { parse, walkSync, ELEMENT_NODE, TEXT_NODE } from 'ultrahtml';
import { unescape } from 'html-escaper';

export const manifest = exportedDocs;
export const documentationOrigin = 'https://help.svetek.com';
export const textContent = (node) => node.type === TEXT_NODE
  ? unescape(node.value)
  : (node.children || []).map(textContent).join('');
export const displayName = (value) => value.replace(/[_-]/g, ' ');
export const localUrl = (value) => value.replace(/^https?:\/\/help\.svetek\.com(?=\/|$)/, '');
export const canonicalUrl = (path) => new URL(path, documentationOrigin).href;

export const docs = manifest.pages.map((record) => {
  const tree = parse(record.html);
  const headings = [];
  walkSync(tree, (node) => {
    if (node.type === ELEMENT_NODE && /^h[23]$/.test(node.name) && node.attributes.id) {
      headings.push({ depth: Number(node.name[1]), id: node.attributes.id, text: textContent(node) });
    }
  });
  const text = textContent(tree).replace(/\s+/g, ' ').trim();
  const title = record.data.title || displayName(record.url.split('/').filter(Boolean).at(-1));
  const description = record.data.description || text.split(' ').slice(0, 30).join(' ');
  const html = record.html.replace(/\b(href|src)=(['"])(https?:\/\/help\.svetek\.com\/[^'"]*)\2/g,
    (match, attribute, quote, value) => `${attribute}=${quote}${localUrl(value)}${quote}`);
  return { ...record, title, description, html, text, headings,
    searchable: record.data.sitemap !== false && !record.url.startsWith('/docs/Legal/') };
});

export const generatedSections = [];
const knownPaths = new Set([...docs.map((page) => page.url), ...Object.keys(manifest.redirects)]);
for (const page of docs) {
  const parts = page.url.split('/').filter(Boolean);
  for (let depth = 1; depth < parts.length; depth += 1) {
    const url = `/${parts.slice(0, depth).join('/')}/`;
    if (knownPaths.has(url)) continue;
    knownPaths.add(url);
    generatedSections.push({ url, title: depth === 1 ? 'Documentation' : displayName(parts[depth - 1]),
      description: depth === 1
        ? 'Practical IT guides, configuration procedures, and troubleshooting from Svetek IT Experts.'
        : `Browse ${displayName(parts[depth - 1])} documentation, guides, and procedures.`,
      data: {}, html: '', text: '', headings: [], searchable: !url.startsWith('/docs/Legal/') });
  }
}
export const pages = [...docs, ...generatedSections].sort((left, right) => left.url.localeCompare(right.url));
export const childrenOf = (url) => pages.filter((page) => page.url !== url &&
  page.url.startsWith(url) && !page.url.slice(url.length).replace(/\/$/, '').includes('/'));
const normalizePath = (path) => path ? `/${path.split('/').filter(Boolean).join('/')}/` : undefined;
const pageAt = (url) => pages.find((page) => page.url === normalizePath(url));
const firstDescendantPath = (item) => item.path ||
  (Array.isArray(item.section) ? item.section.map(firstDescendantPath).find(Boolean) : undefined);
const resolveItem = (item, parentUrl) => {
  const sectionItems = Array.isArray(item.section) ? item.section : [];
  const explicitPath = normalizePath(item.path);
  const descendantPath = normalizePath(firstDescendantPath(item));
  const parentDepth = parentUrl.split('/').filter(Boolean).length;
  const inferredPath = descendantPath
    ? `/${descendantPath.split('/').filter(Boolean).slice(0, parentDepth + 1).join('/')}/`
    : undefined;
  const url = explicitPath || inferredPath;
  const page = pageAt(url);
  return {
    title: item.title || item.sectiontitle || page?.title || displayName(url?.split('/').filter(Boolean).at(-1) || ''),
    url,
    children: sectionItems.map((child) => resolveItem(child, url || parentUrl)).filter((child) => child.url),
  };
};
export const publicSections = manifest.horizontalnav
  .filter((item) => item.node && item.node !== 'home')
  .map((item) => ({ title: item.title, url: normalizePath(item.path), node: item.node }))
  .filter((item) => item.url && pageAt(item.url));
export const curatedTopics = (sectionUrl) => {
  const section = publicSections.find((item) => item.url === normalizePath(sectionUrl));
  if (!section) return [];
  const configured = (manifest.toc[section.node] || [])
    .filter((item) => item.sectiontitle)
    .map((item) => resolveItem(item, section.url))
    .filter((item) => item.url);
  const configuredUrls = new Set(configured.map((item) => item.url));
  const fallback = childrenOf(section.url)
    .filter((item) => item.searchable && !configuredUrls.has(item.url))
    .map((item) => ({ title: item.title, url: item.url, children: [] }));
  return [...configured, ...fallback];
};
export const sidebarItems = (sectionUrl, currentUrl) => {
  const flattenActive = (items, depth = 0) => items.flatMap((item) => [
    { title: item.title, url: item.url, depth },
    ...(currentUrl.startsWith(item.url) ? flattenActive(item.children, depth + 1) : []),
  ]);
  return flattenActive(curatedTopics(sectionUrl));
};
export const landingSections = () => publicSections.map((item) => pageAt(item.url)).filter(Boolean);
export const breadcrumbsFor = (url) => {
  const parts = url.split('/').filter(Boolean);
  return parts.map((part, index) => {
    const path = `/${parts.slice(0, index + 1).join('/')}/`;
    return { url: path, title: pages.find((page) => page.url === path)?.title || displayName(part) };
  });
};
export const ctaFor = (page) => {
  const topic = page.url.split('/')[3];
  const settings = manifest.cta;
  return { ...settings, ...settings.default, ...settings.topics?.[topic],
    ...(page.data.cta_title ? { title: page.data.cta_title } : {}),
    ...(page.data.cta_description ? { description: page.data.cta_description } : {}) };
};
