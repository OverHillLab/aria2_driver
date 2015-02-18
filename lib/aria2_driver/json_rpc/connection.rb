
module Aria2Driver
  module JsonRpc
    class Connection

      DEFAULTS = {
          scheme: 'http',
          port: 80
      }

      attr_reader :scheme, :port, :host

      def initialize(host, options={})
        @host = host
        check_defaults(options)
      end

      private

      def check_defaults(options)
        @scheme = options.fetch(:scheme, DEFAULTS[:scheme])
        @port = options.fetch(:port, DEFAULTS[:port])
      end

    end
  end
end