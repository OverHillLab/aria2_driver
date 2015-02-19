require_relative './request'
require_relative './response'

module Mocks
  module JsonRpc

    class GetVersionResponse < Response

      protected

      def success_response_body(body=nil)
        options[:body] || '"{"id":"local_client",' +
            '"jsonrpc":"2.0",' +
            '"result":{"enabledFeatures":' +
            '["BitTorrent","Firefox3 Cookie",' +
            '"GZip","HTTPS","Message Digest",' +
            '"Metalink","XML-RPC"],' +
            '"version":"1.18.9"}}"'
      end

      def success_response_status(status=nil)
        status || 200
      end
    end

    class GetVersionRequest < Request

      protected

      def rpc_method
        'aria2.getVersion'
      end

      def response_clazz
        GetVersionResponse
      end
    end
  end
end
