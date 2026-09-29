import { docs } from '../lib/docs.mjs';

export function GET() {
  return new Response(JSON.stringify(docs.filter((page) => page.searchable).map((page) => ({
    title: page.title, url: page.url, description: page.description,
    keywords: page.data.keywords || '', text: page.text,
  }))), { headers: { 'Content-Type': 'application/json; charset=utf-8' } });
}
