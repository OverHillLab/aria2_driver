
module Aria2Driver
  module JsonRpc
    class Error
      attr_reader :message, :code, :data

      def initialize(error_hash)
        @code = error_hash['code']
        @message = error_hash['message']
        @data = error_hash['data']
      end
    end
  end
end