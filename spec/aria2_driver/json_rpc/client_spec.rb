require 'spec_helper'

module Aria2Driver
  module JsonRpc


    describe Client do

      it 'should create with defaults' do
        client = Aria2Driver::JsonRpc::Client.new 'localhost', {id: 'my', token: 'abcd-1234'}
        expect(client.id).to eq('my')
        expect(client.token).to eq('abcd-1234')
        expect(client.connection).to have_attributes({
                                                         scheme: Aria2Driver::JsonRpc::Connection::DEFAULTS[:scheme],
                                                         host: 'localhost',
                                                         port: Aria2Driver::JsonRpc::Connection::DEFAULTS[:port]
                                                     })
      end


      it 'should create from url' do
        client = Aria2Driver::JsonRpc::Client.from_url(
            'https://localhost:9090/jsonrpc', {id: 'my', token: 'abcd-1234'})
        expect(client.id).to eq('my')
        expect(client.token).to eq('abcd-1234')
        expect(client.connection).to have_attributes({
                                                         scheme: 'https',
                                                         host: 'localhost',
                                                         port: 9090
                                                     })
      end

      describe 'requests' do
        it 'simple request' do
          stub_request(:post, "http://localhost:9090/jsonrpc").with(
              body: "{\"jsonrpc\":\"2.0\","+
                  "\"method\":\"aria2.getVersion\"," +
                  "\"params\":[\"token:abcd-1234\"]," +
                  "\"id\":\"local_client\"}",
              headers: {
                  'Accept' => 'application/json',
                  'Content-Type' => 'application/json'
              }).to_return({
                               status: 200,
                               body: get_version_response_body
                           })
          client = Aria2Driver::JsonRpc::Client.from_url(
              'https://localhost:9090/jsonrpc', {id: 'local_client', token: 'abcd-1234'})
          response = client.request(Aria2Driver::JsonRpc::Request.new 'aria2.getVersion')
        end
      end

      def get_version_response_body
        '"{"id":"local_client",' +
            '"jsonrpc":"2.0",' +
            '"result":{"enabledFeatures":' +
            '["BitTorrent","Firefox3 Cookie",' +
            '"GZip","HTTPS","Message Digest",' +
            '"Metalink","XML-RPC"],' +
            '"version":"1.18.9"}}"'
      end
    end
  end
end