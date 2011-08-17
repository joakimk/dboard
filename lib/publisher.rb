require 'json'

module Dboard
  class Publisher
    def self.publish(source, data)
      Api::Client.post("/sources/#{source}", :body => { :data => data.to_json })
    rescue SocketError => ex
      puts "SocketError: #{ex.message}"
    end
  end
end
