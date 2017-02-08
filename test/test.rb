require 'net/http'



system("bundle exec cap local pm2:start")

url = URI.parse('http://localhost:3000')
req = Net::HTTP::Get.new(url.to_s)
res = Net::HTTP.start(url.host, url.port) {|http|
  http.request(req)
}

raise 'pm2 didnt start test app' if res.body != 'Hello World!'

system("bundle exec cap local pm2:stop")

puts 'tests passed!'
