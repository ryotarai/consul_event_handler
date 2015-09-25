require 'thor'

module ConsulEventHandler
  class CLI < Thor
    desc 'watch', 'Watch Consul events'
    method_option :config, type: :string, required: true
    def watch
      load_config

      if @config.events.empty?
        raise "No events specified"
      end

      watcher = Consul::EventWatcher.new(@config.consul_url, @config.consul_index_file)
      watcher.watch do |event|
        begin
          body = PayloadLoader.new(@config.secrets).load(event.payload)
          body = JSON.parse(body)

          event_config = @config.events[event.name]
          next unless event_config
          Open3.popen3(*(event_config["command"])) do |stdin, stdout, stderr, wait_thr|
            stdin.close
            p stdout.read
            p stderr.read
            wait_thr.value
          end
        rescue => err
          p err
        end
      end
    end

    private

    def load_config
      @config = Config.new
      @config.load_yaml(options[:config])
    end
  end
end
