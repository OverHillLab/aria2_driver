require_relative './request'
require_relative './response'

module Mocks
  module JsonRpc

    class PurgeDownloadResultSuccessfulResponse < SuccessfulResponse
      def result
        "OK"
      end
    end

    class PurgeDownloadResultRequest < Request

      protected

      def rpc_method
        'aria2.purgeDownloadResult'
      end

    end
  end
end
