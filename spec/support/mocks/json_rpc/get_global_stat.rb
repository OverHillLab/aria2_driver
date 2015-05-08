require_relative './request'
require_relative './response'

module Mocks
  module JsonRpc

    class GetGlobalStatSuccessfulResponse < SuccessfulResponse
      def result
            {
                'downloadSpeed' => '2000',
                'uploadSpeed' => '1000',
                'numActive' => '2',
                'numWaiting' => '1000',
                'numStopped' => '0',
                'numStoppedTotal' => '0'
            }
      end
    end

    class GetGlobalStatRequest < Request

      protected

      def rpc_method
        'aria2.getGlobalStat'
      end

    end
  end
end
