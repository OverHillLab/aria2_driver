require_relative './request'
require_relative './response'

module Mocks
  module JsonRpc

    class TellStatusSuccessfulResponse < SuccessfulResponse
      def result
        keys = request.params[2] || []
        {}.tap do |result_hash|
          general_result.each do |k, v|
            result_hash[k] = v if keys.empty? || keys.include?(k.to_s)
          end
        end
      end

      private

      def general_result
        {
            'gid' => '2089b05ecca3d829',
            'status' => 'active',
            'errorCode' => 0,
            'totalLength' => '34896138',
            'completedLength' => '901120',
            'uploadLength' => '0',
            'bitfield' => '0000000',
            'downloadSpeed' => '2000',
            'uploadSpeed' => '0',
            'connections' => '1',
            'pieceLength' => '1048576',
            'numPieces' => '34',
            'files' => [{
                           'index' => '1',
                           'length' => '34896138',
                           'completedLength' => '34896138',
                           'path' => '/downloads/file',
                           'selected' => 'true',
                           'uris' => [{
                                      'status' => 'used',
                                      'uri' => 'http://example.org/file'}]}],
            'dir' => '/downloads'
        }
      end
    end

    class TellStatusRequest < Request

      protected

      def rpc_method
        'aria2.tellStatus'
      end

    end
  end
end
