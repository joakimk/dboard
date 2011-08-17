module Dboard
  class Config
    @@config ||= {}

    def self.basic_auth(opts = {})
      @@config[:basic_auth] = opts
      Dboard::Api::Client.basic_auth(opts[:user], opts[:password])
    end

    def self.memcache(opts = {})
      @@config[:memcache] = opts
    end

    def self.api(opts = {})
      @@config[:api] = opts
      Dboard::Api::Client.base_uri opts[:uri]
    end

    def self.config
      @@config
    end
  end
end

