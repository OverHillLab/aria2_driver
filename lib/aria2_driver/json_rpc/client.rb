require 'securerandom'
require 'json'

module Aria2Driver
  module JsonRpc
    class Client

      attr_reader :id, :connection, :token

      def initialize(host, options={})
        @id = options[:id] || generate_id
        @token = options[:token]
        options.delete :id
        options.delete :token
        @connection = Aria2Driver::JsonRpc::Connection.new host, options
      end


      def request(request)
        req_hash = request.to_hash
        req_hash[:params].insert(0, "token:#{token}")
        req_hash[:id] = id
        http = Net::HTTP.new(connection.host, connection.port)
        request = Net::HTTP::Post.new(request.path)
        request.body=JSON.generate(req_hash)
        request['Accept'] = 'application/json'
        request['Content-Type'] = 'application/json'

        response = http.request(request)
      end

      def self.from_url(url, options={})
        uri = URI.parse(url)
        new uri.host, options.merge({scheme: uri.scheme, port: uri.port, path: uri.path})
      end

      private

      def generate_id
        SecureRandom.uuid
      end

      def default_path
        Aria2Driver::JsonRpc::Request::DEFAULT_PATH
      end

    end
  end
end