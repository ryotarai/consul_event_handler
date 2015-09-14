require 'logger'

module ConsulEventHandler
  module Logger
    class File < ::Logger
      def initialize(options)
        path = options.fetch('path')
        super(open(path, 'a'))
      end
    end
  end
end
