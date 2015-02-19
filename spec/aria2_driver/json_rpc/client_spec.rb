require 'spec_helper'
require 'support/mocks/json_rpc/get_version'

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
          stubbed_request = Mocks::JsonRpc::GetVersionRequest.new('localhost', {port: 9090, params: ["token:abcd-1234"]})
          stubbed_request.stub.with_success

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