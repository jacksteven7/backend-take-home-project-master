require 'net/http'
require 'uri'
require 'json'

class AccessWorker
  include Sidekiq::Worker

  def perform(user_id)
    user = User.find(user_id)
    uri = URI.parse("https://account-key-service.herokuapp.com/v1/account")
    request = Net::HTTP::Post.new(uri)
    request.content_type = "application/json"
    
    request.body = JSON.dump({
      "email" => user.email,
      "key" => user.key
    })

    req_options = {
      use_ssl: uri.scheme == "https",
    }
    
    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end

    user.update_attributes(account_key: JSON.parse(response.body)["account_key"])
  end
end
