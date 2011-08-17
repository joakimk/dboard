require File.expand_path(File.join(File.dirname(__FILE__), 'cache'))
require File.expand_path(File.join(File.dirname(__FILE__), 'collector.rb'))
require 'digest/md5'
require 'json'
require 'httparty'

module Dboard
  class Api
    MAX_CACHE_TIME = 3600 # seconds
    @@version = nil

    class Client
      include HTTParty
    end

    def self.get(params)
      types = {}
      params[:types].split(',').each do |type|
        raw_data = CACHE.get("dashboard::source::#{type}")
        data = raw_data ? JSON.parse(raw_data) : {}
        types.merge!(type => { :data => data, :checksum => Digest::MD5.hexdigest(data.inspect) })
      end
      { :version => (@@version || ENV["COMMIT_HASH"] || "unversioned"), :sources => types }.to_json
    end

    def self.version=(version)
      @@version = version
    end

    def self.update(params)
      CACHE.set "dashboard::source::#{params[:type]}", params[:data], MAX_CACHE_TIME
    end
  end
end
