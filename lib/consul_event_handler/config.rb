require 'yaml'

module ConsulEventHandler
  class Config
    DEFAULT = {
      "events" => {},
      "loggers" => [
        {"type" => "stdout"},
      ],
      "consul_url" => "http://localhost:8500",
      "consul_index_file" => "/var/lib/itamae-client.consul.index",
    }

    def initialize
      @hash = DEFAULT.dup
    end

    def load_yaml(path)
      @hash.merge!(YAML.load_file(path))
    end

    %w!
    consul_index_file
    consul_url
    loggers
    secrets
    events
    !.each do |m|
      class_eval <<-EOC
      def #{m}
        @hash['#{m}']
      end
      EOC
    end
  end
end
