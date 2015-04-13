require 'securerandom'
require 'json'

require 'aria2_driver/json_rpc/connection'
require 'aria2_driver/json_rpc/request'
require 'aria2_driver/json_rpc/response'
require 'aria2_driver/json_rpc/response_exception'


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
        begin
          http_response = http.request_post(
              request.path,
              JSON.generate(req_hash),
              {
                  'Accept' => 'application/json',
                  'Content-Type' => 'application/json'
              }
          )
          Aria2Driver::JsonRpc::Response.new(JSON.parse(http_response.body))
        rescue Exception => ex
          raise Aria2Driver::JsonRpc::ResponseException.new "Connection Error"
        end
      end


      def method_missing(method, *args)
        if supported_request?(method)
          rpc_method = snake_lower_camel method.to_s
          if args.any?
            request Aria2Driver::JsonRpc::Request.new "aria2.#{rpc_method}", args[0]
          else
            request Aria2Driver::JsonRpc::Request.new "aria2.#{rpc_method}"
          end
        end
      end

      def respond_to_missing?(method, include_private = false)
        supported_request?(method)
      end

      private

      def supported_request?(request)
        [:get_version, :add_uri, :remove, :tell_status].include?(request)
      end

      def snake_lower_camel(snake)
        snake.gsub(/(_.)/) { $1.upcase[-1] }
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

    end
  end
end