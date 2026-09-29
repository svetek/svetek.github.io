require "json"
require "pathname"
require "rexml/document"
require "yaml"

output = Pathname.new(ARGV.fetch(0, "_site_preview"))
failures = []

def ensure_check(condition, message, failures)
  failures << message unless condition
end

required = %w[index.html marketing-preview/index.html docs/Guides/index.html docs/Configuration/index.html css/style.css css/marketing.css js/metadata.json sitemap.xml robots.txt 404.html _headers]
required.each do |path|
  ensure_check(output.join(path).file?, "Missing output: #{path}", failures)
end

Dir.glob("docs/**/index.md").each do |source|
  target = output.join(source.sub(/\.md\z/, ".html"))
  ensure_check(target.file?, "Missing article: #{target}", failures)
end

Dir.glob("docs/**/*").select { |path| File.file?(path) && path.match?(/\.(png|jpe?g|webp|svg|gif|pdf)\z/i) }.each do |path|
  ensure_check(output.join(path).file?, "Missing article asset: #{path}", failures)
end

toc = YAML.load_file("_data/toc.yaml")
navigation_paths = lambda do |items|
  items.flat_map do |item|
    item["section"] ? navigation_paths.call(item["section"]) : [item["path"]].compact
  end
end

%w[guides configuration].each do |node|
  index_path = node == "guides" ? "docs/Guides/index.html" : "docs/Configuration/index.html"
  next unless output.join(index_path).file?
  html = output.join(index_path).read
  groups = toc.fetch(node).select { |item| item["section"] }
  navigation_paths.call(groups).each do |path|
    ensure_check(html.include?("href=\"#{path}\""), "Missing #{node} index link: #{path}", failures)
  end
end

Dir.glob(output.join("**/*.html")).each do |file|
  html = File.read(file)
  ensure_check(html.match?(/<meta\s+name=["']robots["'][^>]*content=["'][^"']*noindex/i), "Preview can be indexed: #{file}", failures)
  ensure_check(!html.include?("googletagmanager.com"), "Analytics enabled in preview: #{file}", failures)
end

marketing = output.join("marketing-preview/index.html")
if marketing.file?
  html = marketing.read
  ensure_check(html.scan(/<h1\b/).length == 1, "Marketing page must have one H1", failures)
  ensure_check(!html.include?("/js/docs.js"), "Docs navigation script loaded on marketing page", failures)
  ensure_check(html.include?("/css/marketing.css"), "Marketing stylesheet missing", failures)
end

edge = output.join("docs/Configuration/Intune/edge-notification-scam-remediation/index.html")
guide = output.join("docs/Guides/index.html")
ensure_check(edge.file? && edge.read.include?("Need help managing your business devices?"), "Intune CTA missing", failures)
ensure_check(guide.file? && !guide.read.include?('class="msp-cta"'), "User guide has an administrator CTA", failures)

search = output.join("js/metadata.json")
if search.file?
  entries = JSON.parse(search.read)
  ensure_check(entries.none? { |entry| entry["url"] == "/marketing-preview/" }, "Preview appears in docs search", failures)
end

sitemap = output.join("sitemap.xml")
if sitemap.file?
  document = REXML::Document.new(sitemap.read)
  locations = REXML::XPath.match(document, "//*[local-name()='loc']").map(&:text)
  ensure_check(locations.none? { |url| url.include?("marketing-preview") || url.include?("localhost") }, "Sitemap includes preview or localhost URL", failures)
end

%w[CNAME Gemfile Gemfile.lock .git _scripts _migration gemfiles vendor node_modules].each do |path|
  ensure_check(!output.join(path).exist?, "Build contains development file: #{path}", failures)
end

abort failures.join("\n") unless failures.empty?
puts "Preview checks passed: #{Dir.glob('docs/**/index.md').length} documentation pages, article assets, indexes, CTAs, metadata, and noindex."
