require_relative './request'
require_relative './response'

module Mocks
  module JsonRpc

    class AddUriSuccessfulResponse < SuccessfulResponse
      def result
        "2089b05ecca3d829"
      end
    end

    class AddUriRequest < Request

      protected

      def rpc_method
        'aria2.addUri'
      end

    end
  end
end
