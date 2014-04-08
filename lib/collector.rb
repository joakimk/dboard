require File.expand_path(File.join(File.dirname(__FILE__), 'publisher'))
require 'singleton'

module Dboard
  class Collector
    include Singleton

    attr_reader :sources

    def self.register_source(key, instance)
      Collector.instance.register_source(key, instance)
    end

    def self.register_after_update_callback(callback)
      Collector.instance.register_after_update_callback(callback)
    end

    def self.start
      instance.start
    end

    def initialize
      @sources = {}
      @after_update_callback = lambda {}
    end

    def start
      @sources.each do |source, instance|
        Thread.new do
          wait_a_little_bit_to_not_start_all_fetches_at_once

          loop do
            update_in_thread(source, instance)
          end
        end
      end
      loop { sleep 1 }
    end

    def register_source(key, instance)
      @sources.merge!({ key => instance })
    end

    def register_after_update_callback(callback)
      @after_update_callback = callback
    end

    # Public because the old tests depend on it
    def update_source(source, instance)
      begin
        data = instance.fetch
        publish_data(source, data)
      ensure
        @after_update_callback.call
      end
    rescue Exception => ex
      puts "Failed to update #{source}: #{ex.message}"
      puts ex.backtrace
    end

    private

    def update_in_thread(source, instance)
      time = Time.now
      puts "#{source} updating..."
      update_source(source, instance)
      elapsed_time = Time.now - time
      time_until_next_update = instance.update_interval - elapsed_time
      time_until_next_update = 0 if time_until_next_update < 0
      puts "#{source} done in #{elapsed_time} seconds, will update again in #{time_until_next_update} seconds (interval: #{instance.update_interval})."
      sleep time_until_next_update
    rescue Exception => ex
      puts "Something failed outside the update_source method. #{ex.message}"
      puts ex.backtrace
    end

    def publish_data(source, data)
      Publisher.publish(source, data)
    end

    def wait_a_little_bit_to_not_start_all_fetches_at_once
      sleep 10 * rand
    end
  end
end
