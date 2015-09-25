require "consul_event_handler/cli"
require "consul_event_handler/config"
require "consul_event_handler/consul"
require "consul_event_handler/logger"
require "consul_event_handler/payload_loader"
require "consul_event_handler/version"

module ConsulEventHandler
  class << self
    attr_accessor :logger

    def reset_logger
      @logger ||= ::Logger.new($stdout)
    end
  end

  reset_logger
end
