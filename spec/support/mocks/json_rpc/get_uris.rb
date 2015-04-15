require_relative './request'
require_relative './response'

module Mocks
  module JsonRpc

    class GetUrisSuccessfulResponse < SuccessfulResponse
      def result
        [
            {
                'status' => 'used',
                'uri' => 'http://example.org/file'
            }
        ]
      end
    end

    class GetUrisRequest < Request

      protected

      def rpc_method
        'aria2.getUris'
      end

    end
  end
end
