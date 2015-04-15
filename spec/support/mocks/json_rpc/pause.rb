require_relative './request'
require_relative './response'

module Mocks
  module JsonRpc

    class PauseSuccessfulResponse < SuccessfulResponse
      def result
        "2089b05ecca3d829"
      end
    end

    class PauseRequest < Request

      protected

      def rpc_method
        'aria2.pause'
      end

    end
  end
end
