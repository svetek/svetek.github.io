import { docs, canonicalUrl } from '../lib/docs.mjs';
import { escape } from 'html-escaper';

export function GET() {
  const locations = docs.filter((page) => page.searchable).map((page) =>
    `<url><loc>${escape(page.data.canonical || canonicalUrl(page.url))}</loc></url>`);
  return new Response(`<?xml version="1.0" encoding="UTF-8"?><urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">${locations.join('')}</urlset>`,
    { headers: { 'Content-Type': 'application/xml; charset=utf-8' } });
}
