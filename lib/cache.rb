require 'dalli'

module Dboard
  if Config.config[:memcache]
    CACHE = Dalli::Client.new(Config.config[:memcache])
  else
    CACHE = Dalli::Client.new("127.0.0.1:11211")
  end
end

