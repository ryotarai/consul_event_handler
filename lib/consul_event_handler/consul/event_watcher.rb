require 'json'
require 'base64'
require 'pathname'
require 'faraday'

require 'consul_event_handler/consul/event'

module ConsulEventHandler
  module Consul
    class EventWatcher
      def initialize(url, index_file)
        @url = url
        @index_file = Pathname.new(index_file)
      end

      def watch
        conn = Faraday.new(:url => @url) do |faraday|
          faraday.request  :url_encoded             # form-encode POST params
          # faraday.response :logger                  # log requests to STDOUT
          faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
        end

        unless @index_file.exist?
          res = conn.get("/v1/event/list")
          @index_file.write(res.headers["X-Consul-Index"])
        end

        while true
          begin
            ConsulEventHandler.logger.debug "waiting for a new event"
            res = conn.get do |req|
              req.url "/v1/event/list"
              req.params['index'] = @index_file.read
              req.options.timeout = 60 * 10 # 10 min
            end
          rescue Faraday::TimeoutError
            retry
          rescue Faraday::ConnectionFailed
            ConsulEventHandler.logger.warn "connection to Consul failed. will retry after 60 sec"
            sleep 60
            retry
          end

          if 200 <= res.status && res.status < 300
            @index_file.write(res.headers["X-Consul-Index"])

            event_hash = JSON.parse(res.body).last
            next unless event_hash

            ConsulEventHandler.logger.info "new event: #{event_hash["ID"]}"
            event = Event.new.tap do |e|
              e.name = event_hash.fetch('Name')

              payload = event_hash.fetch('Payload')
              if payload
                e.payload = Base64.decode64(payload)
              end
            end

            yield(event)
          else
            # retry
            sleep 60
          end
        end
      end
    end
  end
end
