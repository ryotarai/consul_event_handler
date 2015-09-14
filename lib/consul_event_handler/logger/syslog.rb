require "syslog/logger"

module ConsulEventHandler
  module Logger
    class Syslog < ::Syslog::Logger
      def initialize(options)
        program_name = options['program_name'] || 'consul_event_handler'
        facility = options['facility']
        super(program_name, facility)
      end
    end
  end
end
