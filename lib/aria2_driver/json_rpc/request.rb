require 'net/http'
require 'json'

module Aria2Driver
  module JsonRpc
    class Request

      DEFAULT_PATH = '/jsonrpc'
      JSON_RPC_VERSION = '2.0'

      attr_reader :rpc_method, :params, :path

      def initialize(rpc_method, options={})
        @path = options[:path] || DEFAULT_PATH
        @rpc_method = rpc_method
        @params = options[:params] || []
      end

      def to_hash
        {
            jsonrpc: JSON_RPC_VERSION,
            method: rpc_method,
            params: params
        }
      end
    end
  end
end