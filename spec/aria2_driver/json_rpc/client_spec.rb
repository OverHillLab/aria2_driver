require 'spec_helper'
require 'support/mocks/json_rpc/get_version'
require 'support/mocks/json_rpc/add_uri'

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
        it 'simple successful generic request' do
          stubbed_request = Mocks::JsonRpc::GetVersionRequest.new('localhost', {port: 80, params: ["token:abcd-1234"]})
          mock_response = Mocks::JsonRpc::GetVersionSuccessfulResponse.new
          stubbed_request.with_response(mock_response)

          client = Aria2Driver::JsonRpc::Client.from_url(
              'https://localhost:80/jsonrpc', {id: 'local_client', token: 'abcd-1234'})
          response = client.request(Aria2Driver::JsonRpc::Request.new 'aria2.getVersion')

          expect(response.error?).to be_falsey
          expect(response.result['version']).to eq(mock_response.result[:version])
          expect(response.result['enabledFeatures']).to eq(mock_response.result[:enabledFeatures])
        end

        it 'simple unsuccessful generic request' do
          stubbed_request = Mocks::JsonRpc::GetVersionRequest.new('localhost', {port: 80, params: ["token:abcd-1234"]})
          mock_error_response = Mocks::JsonRpc::ErrorResponse.new({code: -32700, message: 'Parse error'})
          stubbed_request.with_response(mock_error_response)

          client = Aria2Driver::JsonRpc::Client.from_url(
              'https://localhost:80/jsonrpc', {id: 'local_client', token: 'abcd-1234'})
          response = client.request(Aria2Driver::JsonRpc::Request.new 'aria2.getVersion')

          expect(response.error?).to be_truthy
          expect(response.error).to have_attributes({
                                                        code: mock_error_response.code,
                                                        message: mock_error_response.message
                                                    })
        end

        it 'get_version request' do
          stubbed_request = Mocks::JsonRpc::GetVersionRequest.new('localhost', {port: 80, params: ["token:abcd-1234"]})
          mock_response = Mocks::JsonRpc::GetVersionSuccessfulResponse.new
          stubbed_request.with_response(mock_response)

          aria2 = Aria2Driver::JsonRpc::Client.from_url(
              'https://localhost:80/jsonrpc', {id: 'local_client', token: 'abcd-1234'})

          expect(aria2.respond_to?(:get_version)).to be true

          response = aria2.get_version

          expect(response.error?).to be_falsey
          expect(response.result['version']).to eq(mock_response.result[:version])
          expect(response.result['enabledFeatures']).to eq(mock_response.result[:enabledFeatures])
        end

        it 'add_uri request' do
          stubbed_request = Mocks::JsonRpc::AddUriRequest.new('localhost',
                                                              {
                                                                  port: 80,
                                                                  params: [
                                                                      "token:abcd-1234",
                                                                      ['http://www.example.com/a.jpg'],
                                                                      {"dir" => "/tmp/"}
                                                                  ]
                                                              })
          mock_response = Mocks::JsonRpc::AddUriSuccessfulResponse.new
          stubbed_request.with_response(mock_response)

          aria2 = Aria2Driver::JsonRpc::Client.from_url(
              'https://localhost:80/jsonrpc', {id: 'local_client', token: 'abcd-1234'})

          response = aria2.add_uri({params: [['http://www.example.com/a.jpg'], {"dir" => "/tmp/"}]})

          expect(response.error?).to be_falsey
          expect(response.result).to eq(mock_response.result)
        end

      end
    end
  end
end