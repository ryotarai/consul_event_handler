require "consul_event_handler/logger/stdout"
require "consul_event_handler/logger/syslog"
require "consul_event_handler/logger/file"
require "consul_event_handler/logger/cloud_watch_logs"

module ConsulEventHandler
  module Logger
    def self.class_from_type(type)
      name = type.split('_').map(&:capitalize).join
      self.const_get(name)
    end
  end
end
