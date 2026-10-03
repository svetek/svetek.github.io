// @ts-check
import { defineConfig } from 'astro/config';

// https://astro.build/config
export default defineConfig({
  trailingSlash: 'always',
  // Design B moved from /logo/ to the homepage.
  redirects: { '/logo/': '/' },
});
