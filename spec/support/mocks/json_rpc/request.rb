require 'webmock/rspec'

module Mocks
  module JsonRpc

    class Request
      attr_reader :request_method, :uri, :body, :headers, :params,
                  :client_id, :json_rpc_version, :stubbed_request

      DEFAULT_HEADERS = {
          'Accept' => 'application/json',
          'Content-Type' => 'application/json'
      }
      DEFAULT_SCHEME = 'http'
      DEFAULT_PORT = 80
      DEFAULT_PATH = 'jsonrpc'
      DEFAULT_CLIENT_ID = 'fake_id'
      DEFAULT_JSON_RPC_VERSION = '2.0'


      def initialize(host, options={})
        @request_method = options[:method] || :post
        @uri = build_uri(
            host, options[:path] || DEFAULT_PATH,
            options[:port] || DEFAULT_PORT,
            options[:scheme] || DEFAULT_SCHEME)
        @params = options[:params] || []
        @client_id = options[:client_id] || DEFAULT_CLIENT_ID
        @json_rpc_version = options[:json_rpc_version] || DEFAULT_JSON_RPC_VERSION
        set_headers DEFAULT_HEADERS
        stub_request
      end

      def with_response(response)
        request rpc_method, response
      end


      protected

      def rpc_method
        raise NotImplementedError
      end

      private

      def request(rpc, response)
        set_body(rpc, params) if !params.empty?
        response.stub_for self
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

      def stub_request
        @stubbed_request = WebMock::API.stub_request(
            request_method, uri
        )
      end

      def set_headers(headers)
        @headers = headers
      end
    end
  end
end


