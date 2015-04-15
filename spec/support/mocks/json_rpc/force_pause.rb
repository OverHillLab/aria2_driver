require_relative './request'
require_relative './response'

module Mocks
  module JsonRpc

    class ForcePauseSuccessfulResponse < SuccessfulResponse
      def result
        "2089b05ecca3d829"
      end
    end

    class ForcePauseRequest < Request

      protected

      def rpc_method
        'aria2.forcePause'
      end

    end
  end
end
