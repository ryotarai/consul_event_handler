module ConsulEventHandler
  module Consul
    class Event < Struct.new(:payload)
    end
  end
end
