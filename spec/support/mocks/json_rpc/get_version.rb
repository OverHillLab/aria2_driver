require_relative './request'
require_relative './response'

module Mocks
  module JsonRpc

    class GetVersionSuccessfulResponse < SuccessfulResponse
      def result
        {
            'enabledFeatures' => ["BitTorrent",
                                 "Firefox3 Cookie",
                                 "GZip", "HTTPS",
                                 "Message Digest",
                                 "Metalink", "XML-RPC"],
            'version' => "1.18.9"
        }
      end
    end

    class GetVersionRequest < Request

      protected

      def rpc_method
        'aria2.getVersion'
      end

    end
  end
end
