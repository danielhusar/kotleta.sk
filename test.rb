require "yaml"
require "net/http"

articles = YAML::load(File.open("_config.yml"))["articles"]
fail "Articles is not array" unless articles.kind_of?(Array)

urls = articles.map { |article| article['url'] }
fail "Duplicated urls" unless urls.size == urls.uniq.size

urls.each do |u|
  url = URI.parse(u)
  req = Net::HTTP::Get.new(url.to_s)
  http = Net::HTTP.new(url.host, url.port)
  http.use_ssl = true if u.start_with?("https")
  res = http.request(req)
  puts "#{res.code}: #{u}" if res.code == "404"
end

