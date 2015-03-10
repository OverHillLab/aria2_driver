module Aria2Driver
  module JsonRpc
    class ResponseException < StandardError
      def initialize(message)
        super(message)
      end
    end
  end
end
