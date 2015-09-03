require_relative 'keys'

def get_info(username, query, path)
  consumer_key
  access_token
  baseurl = "https://api.twitter.com"
  address = URI("#{baseurl}#{path}?#{query}")
  request = Net::HTTP::Get.new address.request_uri
  http = Net::HTTP.new address.host, address.port
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_PEER
  request.oauth! http, consumer_key, access_token
  http.start
  response = http.request request
  info = nil
  if response.code == '200' then
    info = JSON.parse(response.body)
  end
  info
end

def get_tweets(username)
  query = URI.encode_www_form("screen_name" => username, "count" => 25)
  path = "/1.1/statuses/user_timeline.json"
  get_info(username, query, path)
end

def get_user_info(username)
  query = URI.encode_www_form("screen_name" => username)
  path = "/1.1/users/show.json"
  get_info(username, query, path)
end
