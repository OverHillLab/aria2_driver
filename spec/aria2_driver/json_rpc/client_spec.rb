require 'spec_helper'
require 'support/mocks/json_rpc/get_version'
require 'support/mocks/json_rpc/add_uri'
require 'support/mocks/json_rpc/remove'
require 'support/mocks/json_rpc/force_remove'
require 'support/mocks/json_rpc/tell_status'

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
        client = Aria2Driver::JsonRpc::Client.new 'localhost', {
                                                                 id: 'my',
                                                                 scheme: 'https',
                                                                 port: 9090,
                                                                 token: 'abcd-1234'
                                                             }
        expect(client.id).to eq('my')
        expect(client.token).to eq('abcd-1234')
        expect(client.connection).to have_attributes({
                                                         scheme: 'https',
                                                         host: 'localhost',
                                                         port: 9090
                                                     })
      end


      describe 'requests' do

        let :aria2 do
          Aria2Driver::JsonRpc::Client.new 'localhost', {
                                                          id: 'local_client',
                                                          token: 'abcd-1234'
                                                      }
        end

        it 'simple successful generic request' do
          stubbed_request = Mocks::JsonRpc::GetVersionRequest.new('localhost',
                                                                  {
                                                                      port: 80,
                                                                      params: ["token:abcd-1234"]
                                                                  })
          mock_response = Mocks::JsonRpc::GetVersionSuccessfulResponse.new
          stubbed_request.with_response(mock_response)

          response = aria2.request(Aria2Driver::JsonRpc::Request.new 'aria2.getVersion')

          expect(response.error?).to be_falsey
          expect(response.result['version']).to eq(mock_response.result['version'])
          expect(response.result['enabledFeatures']).to eq(mock_response.result['enabledFeatures'])
        end

        it 'simple unsuccessful generic request' do
          stubbed_request = Mocks::JsonRpc::GetVersionRequest.new('localhost', {port: 80, params: ["token:abcd-1234"]})
          mock_error_response = Mocks::JsonRpc::ErrorResponse.new({code: -32700, message: 'Parse error'})
          stubbed_request.with_response(mock_error_response)

          response = aria2.request(Aria2Driver::JsonRpc::Request.new 'aria2.getVersion')

          expect(response.error?).to be_truthy
          expect(response.error).to have_attributes({
                                                        code: mock_error_response.code,
                                                        message: mock_error_response.message
                                                    })
        end

        it 'handle connection refused on request' do
          stub_request(:any, 'http://localhost:80/jsonrpc').to_raise(Errno::ECONNREFUSED)

          expect{aria2.request(Aria2Driver::JsonRpc::Request.new 'aria2.getVersion')}
              .to raise_error(Aria2Driver::JsonRpc::ResponseException)
        end

        describe 'version' do
          it 'get_version request' do
            stubbed_request = Mocks::JsonRpc::GetVersionRequest.new('localhost', {port: 80, params: ["token:abcd-1234"]})
            mock_response = Mocks::JsonRpc::GetVersionSuccessfulResponse.new
            stubbed_request.with_response(mock_response)

            expect(aria2.respond_to?(:get_version)).to be true

            response = aria2.get_version

            expect(response.error?).to be_falsey
            expect(response.result['version']).to eq(mock_response.result['version'])
            expect(response.result['enabledFeatures']).to eq(mock_response.result['enabledFeatures'])
          end
        end

        describe 'add uri' do
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

            response = aria2.add_uri({params: [['http://www.example.com/a.jpg'], {"dir" => "/tmp/"}]})

            expect(response.error?).to be_falsey
            expect(response.result).to eq(mock_response.result)
          end
        end

        describe 'remove' do
          it 'remove request' do
            stubbed_request = Mocks::JsonRpc::RemoveRequest.new('localhost',
                                                                {
                                                                    port: 80,
                                                                    params: [
                                                                        'token:abcd-1234',
                                                                        '2089b05ecca3d829'
                                                                    ]
                                                                })
            mock_response = Mocks::JsonRpc::RemoveSuccessfulResponse.new
            stubbed_request.with_response(mock_response)

            response = aria2.remove({params: ['2089b05ecca3d829']})

            expect(response.error?).to be_falsey
            expect(response.result).to eq(mock_response.result)
          end
        end

        describe 'force remove' do
          it 'remove request using force' do
            stubbed_request = Mocks::JsonRpc::ForceRemoveRequest.new('localhost',
                                                                {
                                                                    port: 80,
                                                                    params: [
                                                                        'token:abcd-1234',
                                                                        '2089b05ecca3d829'
                                                                    ]
                                                                })
            mock_response = Mocks::JsonRpc::ForceRemoveSuccessfulResponse.new
            stubbed_request.with_response(mock_response)

            response = aria2.force_remove({params: ['2089b05ecca3d829']})

            expect(response.error?).to be_falsey
            expect(response.result).to eq(mock_response.result)
          end
        end

        describe 'status' do
          it 'tell_status simple request' do
            stubbed_request = Mocks::JsonRpc::TellStatusRequest.new('localhost',
                                                                    {
                                                                        port: 80,
                                                                        params: [
                                                                            'token:abcd-1234',
                                                                            '2089b05ecca3d829'
                                                                        ]
                                                                    })
            mock_response = Mocks::JsonRpc::TellStatusSuccessfulResponse.new
            stubbed_request.with_response(mock_response)

            response = aria2.tell_status({params: ["2089b05ecca3d829"]})

            expect(response.error?).to be_falsey
            expect(response.result).to eq(mock_response.result)
          end

          it 'tell_status request with selected keys' do
            stubbed_request = Mocks::JsonRpc::TellStatusRequest.new('localhost',
                                                                    {
                                                                        port: 80,
                                                                        params: [
                                                                            "token:abcd-1234",
                                                                            "2089b05ecca3d829",
                                                                            ["gid", "status"]
                                                                        ]
                                                                    })
            mock_response = Mocks::JsonRpc::TellStatusSuccessfulResponse.new
            stubbed_request.with_response(mock_response)

            response = aria2.tell_status({params: ["2089b05ecca3d829", ['gid', 'status']]})

            expect(response.error?).to be_falsey
            expect(response.result).to eq({"gid" => "2089b05ecca3d829", "status" => "active"})
          end
        end
      end
    end

  end
end