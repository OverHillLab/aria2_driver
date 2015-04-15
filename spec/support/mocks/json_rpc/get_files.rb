require_relative './request'
require_relative './response'

module Mocks
  module JsonRpc

    class GetFilesSuccessfulResponse < SuccessfulResponse
      def result
        [
            {
                'index' => '1',
                'length' => '34896138',
                'completedLength' => '34896138',
                'path' => '/downloads/file',
                'selected' => 'true',
                'uris' => [
                    {
                        'status' => 'used',
                        'uri' => 'http://example.org/file'
                    }
                ]
            }
        ]
      end
    end

    class GetFilesRequest < Request

      protected

      def rpc_method
        'aria2.getFiles'
      end

    end
  end
end
