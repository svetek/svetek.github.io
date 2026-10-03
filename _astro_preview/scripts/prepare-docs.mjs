import { execFileSync } from 'node:child_process';
import { fileURLToPath } from 'node:url';
import { readFileSync, writeFileSync } from 'node:fs';

const root = fileURLToPath(new URL('../../', import.meta.url));
const preview = fileURLToPath(new URL('../', import.meta.url));
execFileSync('bundle', ['exec', 'ruby', `${preview}scripts/export-docs.rb`], {
  cwd: root,
  env: { ...process.env, BUNDLE_GEMFILE: `${root}gemfiles/cloudflare.gemfile` },
  stdio: 'inherit',
});
const { redirects } = JSON.parse(readFileSync(`${preview}.generated/docs.json`, 'utf8'));
writeFileSync(`${preview}public/_headers`, '/*\n  X-Robots-Tag: noindex, nofollow\n');
writeFileSync(`${preview}public/robots.txt`, 'User-agent: *\nAllow: /\n');
writeFileSync(`${preview}public/_redirects`, Object.entries({ ...redirects, '/logo/': '/' })
  .map(([from, to]) => `${from} ${to} 301`).join('\n') + '\n');
