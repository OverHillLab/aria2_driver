require_relative './request'
require_relative './response'

module Mocks
  module JsonRpc

    class RemoveSuccessfulResponse < SuccessfulResponse
      def result
        "2089b05ecca3d829"
      end
    end

    class RemoveRequest < Request

      protected

      def rpc_method
        'aria2.remove'
      end

    end
  end
end
