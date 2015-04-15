require_relative './request'
require_relative './response'

module Mocks
  module JsonRpc

    class ForceRemoveSuccessfulResponse < SuccessfulResponse
      def result
        "2089b05ecca3d829"
      end
    end

    class ForceRemoveRequest < Request

      protected

      def rpc_method
        'aria2.forceRemove'
      end

    end
  end
end
