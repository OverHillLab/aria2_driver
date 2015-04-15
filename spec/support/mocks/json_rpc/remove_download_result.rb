require_relative './request'
require_relative './response'

module Mocks
  module JsonRpc

    class RemoveDownloadResultSuccessfulResponse < SuccessfulResponse
      def result
        "OK"
      end
    end

    class RemoveDownloadResultRequest < Request

      protected

      def rpc_method
        'aria2.removeDownloadResult'
      end

    end
  end
end
