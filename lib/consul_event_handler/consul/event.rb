module ConsulEventHandler
  module Consul
    class Event < Struct.new(:payload, :name)
    end
  end
end
