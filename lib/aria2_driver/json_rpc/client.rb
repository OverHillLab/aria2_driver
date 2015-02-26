require 'securerandom'
require 'json'

module Aria2Driver
  module JsonRpc
    class Client

      attr_reader :id, :connection, :token

      def initialize(host, options={})
        @id = options[:id] || generate_uuid
        @token = options[:token]
        options.delete :id
        options.delete :token
        @connection = Aria2Driver::JsonRpc::Connection.new host, options
      end


      def request(request)
        req_hash = request_to_hash(request)
        http = Net::HTTP.new(connection.host, connection.port)
        request = build_http_request(req_hash, request)

        http_response = http.request(request)

        Aria2Driver::JsonRpc::Response.new(JSON.parse(http_response.body))
      end

      def self.from_url(url, options={})
        uri = URI.parse(url)
        new uri.host, options.merge({scheme: uri.scheme, port: uri.port, path: uri.path})
      end

      def method_missing(method, *args)
        rpc_method = snake_lower_camel method.to_s
        if supported_request?(rpc_method)
          request Aria2Driver::JsonRpc::Request.new "aria2.#{rpc_method}"
        end
      end

      def respond_to_missing?(method, include_private = false)
        supported_request?(snake_lower_camel(method.to_s))
      end

      private

      def supported_request?(request)
        %w(getVersion).include?(request)
      end

      def snake_lower_camel(snake)
        snake.gsub(/(_.)/){ $1.upcase[-1] }
      end

      def generate_uuid
        SecureRandom.uuid
      end

      def request_to_hash(request)
        req_hash = request.to_hash
        req_hash[:params].insert(0, "token:#{token}")
        req_hash[:id] = id
        req_hash
      end

      def build_http_request(req_hash, request)
        Net::HTTP::Post.new(request.path).tap do |request|
          request.body=JSON.generate(req_hash)
          request['Accept'] = 'application/json'
          request['Content-Type'] = 'application/json'
        end
      end

    end
  end
end