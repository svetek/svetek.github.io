require "bundler/setup"
require "jekyll"
require "json"
require "fileutils"
require "digest"

root = File.expand_path("../..", __dir__)
preview = File.join(root, "_astro_preview")
config = Jekyll.configuration({
  "source" => root,
  "config" => [File.join(root, "_config.yml"), File.join(root, "_config_production.yml")],
  "destination" => File.join(preview, ".generated", "unused"),
  "incremental" => false,
  "quiet" => true,
  "url" => "https://help.svetek.com",
  "google_analytics" => "",
  "polldaddy_id" => ""
})
config["exclude"] += %w[_astro_preview _site _site_preview]
site = Jekyll::Site.new(config)
site.reset
site.read
pages = site.pages.select { |page| page.path.start_with?("docs/") && page.ext == ".md" }
redirects = {}
pages.each do |page|
  redirects[page.url] = page.data.dig("redirect", "to") if page.data.dig("redirect", "to")
  Array(page.data["redirect_from"]).each { |path| redirects[path] = page.url }
end
records = pages.reject { |page| redirects.key?(page.url) }.map do |page|
  metadata = page.data.dup
  page.data["layout"] = nil
  html = Jekyll::Renderer.new(site, page).run
  { "url" => page.url, "source" => page.path, "data" => metadata, "html" => html }
end
assets = site.static_files.select { |file| file.relative_path.match?(%r{\A/(docs|images|favicons)/}) }
# Start from empty copies so files deleted from the repository are not deployed.
%w[docs images favicons].each { |dir| FileUtils.rm_rf(File.join(preview, "public", dir)) }
asset_records = assets.map do |file|
  path = file.relative_path.delete_prefix("/")
  target = File.join(preview, "public", path)
  FileUtils.mkdir_p(File.dirname(target))
  FileUtils.cp(file.path, target)
  { "path" => "/#{path}", "sha256" => Digest::SHA256.file(file.path).hexdigest }
end
FileUtils.mkdir_p(File.join(preview, ".generated"))
File.write(File.join(preview, ".generated", "docs.json"), JSON.pretty_generate({
  "pages" => records,
  "sources" => pages.map { |page| { "source" => page.path, "url" => page.url } },
  "redirects" => redirects,
  "assets" => asset_records,
  "cta" => site.data["msp"],
  "toc" => site.data["toc"],
  "horizontalnav" => site.data.dig("toc", "horizontalnav")
}))
puts "Exported #{records.length} document bodies, #{redirects.length} redirects, #{asset_records.length} assets."
