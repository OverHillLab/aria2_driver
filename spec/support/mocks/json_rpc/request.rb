require 'webmock/rspec'

module Mocks
  module JsonRpc

    class Request
      attr_reader :request_method, :uri, :body, :headers, :params

      DEFAULT_HEADERS = {
          'Accept' => 'application/json',
          'Content-Type' => 'application/json'
      }
      DEFAULT_SCHEME = 'http'
      DEFAULT_PORT = 80
      DEFAULT_PATH = 'jsonrpc'
      DEFAULT_CLIENT_ID = 'fake_id'


      def initialize(host, options={})
        @request_method = options[:method] || :post
        @uri = build_uri(
            host, options[:path] || DEFAULT_PATH,
            options[:port] || DEFAULT_PORT,
            options[:scheme] || DEFAULT_SCHEME)
        @params = options[:params] || []
        @client_id = options[:client_id] || DEFAULT_CLIENT_ID
        set_headers DEFAULT_HEADERS
      end

      def stub()
        request rpc_method, params, response_clazz
      end


      protected

      def rpc_method
        raise NotImplementedError
      end

      def response_clazz
        raise NotImplementedError
      end

      private

      def request(rpc, params, clazz)
        set_body(rpc, params) if !params.empty?
        clazz.new self
      end

      def build_uri(host, path, port, scheme)
        "#{scheme}://#{host}:#{port}/#{path}"
      end

      def set_body(rpc_method, params)
        @body = JSON.generate({
                                  jsonrpc: '2.0',
                                  method: rpc_method,
                                  params: params,
                                  id: 'local_client'
                              })
      end

      def set_headers(headers)
        @headers = headers
      end
    end
  end
end


