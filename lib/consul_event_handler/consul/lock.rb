require 'open3'

module ConsulEventHandler
  module Consul
    class Lock
      def initialize(prefix, limit)
        @prefix = prefix
        @limit = limit
      end

      def with_lock(timeout_sec = 24 * 60 * 60)
        # TODO: Reimplement with Consul HTTP API
        args = ["consul", "lock", "-n", @limit.to_s, @prefix, "echo START; sleep #{timeout_sec + 60}"]
        Itamae::Client.logger.debug args.shelljoin
        Open3.popen3(*args) do |stdin, stdout, stderr, wait_thr|
          begin
            line = stdout.readline
            unless line.chomp == "START"
              raise "failed to obtain a lock: #{line}"
            end

            lock_thread = Thread.start do
              wait_thr.join # blocking
              raise "lock is gone"
            end
            lock_thread.abort_on_exception = true

            yield
          ensure
            lock_thread.terminate if lock_thread
            Process.kill(:TERM, wait_thr[:pid]) if wait_thr.alive?
          end
        end
      end
    end
  end
end
