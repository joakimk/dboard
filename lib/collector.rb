require File.expand_path(File.join(File.dirname(__FILE__), 'publisher'))
require 'singleton'

module Dboard
  class Collector
    include Singleton

    attr_reader :sources

    def self.register_source(key, instance)
      Collector.instance.register_source(key, instance)
    end

    def self.start
      instance.start
    end

    def initialize
      @sources = {}
    end

    def start
      @sources.each do |source, instance|
        Thread.new do
          loop do
            time = Time.now
            puts "#{source} updating..."
            update_source(source, instance)
            elapsed_time = Time.now - time
            time_until_next_update = instance.update_interval - elapsed_time
            time_until_next_update = 0 if time_until_next_update < 0
            puts "#{source} done in #{elapsed_time} seconds, will update again in #{time_until_next_update} seconds (interval: #{instance.update_interval})."
            sleep time_until_next_update
          end
        end
      end
      loop { sleep 1 }
    end

    def update_source(source, instance)
      data = instance.fetch
      publish_data(source, data)
    rescue Exception => ex
      puts "Failed to update #{source}: #{ex.message}"
      puts ex.backtrace
    end

    def register_source(key, instance)
      @sources.merge!({ key => instance })
    end

    def publish_data(source, data)
      Publisher.publish(source, data)
    end
  end
end
