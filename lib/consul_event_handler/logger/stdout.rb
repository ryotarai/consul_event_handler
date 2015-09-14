require 'logger'

module ConsulEventHandler
  module Logger
    class Stdout < ::Logger
      def initialize(options)
        super($stdout)
      end
    end
  end
end
