module Mocks
  module JsonRpc
    class Response
      attr_reader :request, :response_body, :response_status

      def initialize(request)
        @request = request
      end

      def with_success(options={})
        stubbed_request = WebMock::API.stub_request(
            request.request_method, request.uri
        )
        with_hash = {}
        with_hash[:body] = request.body if request.body
        with_hash[:headers] = request.headers if request.headers

        stubbed_request.with(with_hash) if !with_hash.empty?

        stubbed_request.to_return({
                                      status: options[:status] || success_response_status,
                                      body: options[:body] || response_body
                                  })
      end

      protected

      def success_response_body(body=nil)
        raise NotImplementedError
      end

      def success_response_status(status=nil)
        raise NotImplementedError
      end
    end
  end
end
