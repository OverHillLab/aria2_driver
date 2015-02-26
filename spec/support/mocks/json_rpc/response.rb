module Mocks
  module JsonRpc
    class Response

      attr_reader :request

      def stub_for(request)
        @request = request
        stubbed_request = WebMock::API.stub_request(
            request.request_method, request.uri
        )
        with_hash = {}
        with_hash[:body] = request.body if request.body
        with_hash[:headers] = request.headers if request.headers

        stubbed_request.with(with_hash) if !with_hash.empty?

        stubbed_request.to_return({
                                      status: response_status(),
                                      body: response_body()
                                  })
      end

      protected

      def response_body
        raise NotImplementedError
      end

      def response_status
        raise NotImplementedError
      end
    end

    class SuccessfulResponse < Response

      def initialize(options={})
        @result = options[:result] || {}
      end

      def result
        @result
      end

      protected

      def response_body
        JSON.generate({
                          jsonrpc: request.json_rpc_version,
                          result: result,
                          client_id: request.client_id
                      })
      end

      def response_status
        200
      end

    end

    class ErrorResponse < Response

      attr_reader :message, :code, :data

      DEFAULT_ERROR_CODE = -3200
      DEFAULT_ERROR_MESSAGE = 'Server error'

      def initialize(options={})
        @code = options[:code] || DEFAULT_ERROR_CODE
        @message = options[:message] || DEFAULT_ERROR_MESSAGE
        @data = options[:data]
      end

      def response_body
        JSON.generate({
                          jsonrpc: request.json_rpc_version,
                          error: {}.tap do |error|
                            error[:code] = code
                            error[:message] = message
                            error[:data] = data if data
                          end,
                          client_id: request.client_id
                      })
      end

      def response_status
        200
      end
    end
  end
end
