require 'spec_helper'

module Aria2Driver
  module JsonRpc
    describe Response do

      let :successful_response do
        {
            'id' =>  'local_client',
            'jsonrpc' => '2.0',
            'result' => {
                'enabledFeatures' => ['BitTorrent','Gzip'],
                'version' => '1.18.9'
            }
        }
      end

      let :error_response do
        {
            'id' =>  'local_client',
            'jsonrpc' => '2.0',
            'error' => {
                'code' => 3600,
                'message' => 'invalid request'
            }
        }
      end

      it 'should build a response with a result' do
        response = Aria2Driver::JsonRpc::Response.new successful_response

        expect(response.id).to eq('local_client')
        expect(response.jsonrpc).to eq('2.0')
        expect(response.error?).to be_falsey
        expect(response.error).to be_nil

        result = response.result

        expect(result).not_to be_nil
        expect(result['version']).to eq('1.18.9')
        expect(result['enabledFeatures']).to eq(['BitTorrent','Gzip'])
      end

      it 'should build a response with a error' do
        response = Aria2Driver::JsonRpc::Response.new error_response

        expect(response.id).to eq('local_client')
        expect(response.jsonrpc).to eq('2.0')
        expect(response.error?).to be_truthy
        expect(response.result).to be_nil

        error = response.error

        expect(error).not_to be_nil
        expect(error.code).to eq(error_response['error']['code'])
        expect(error.message).to eq(error_response['error']['message'])
      end
    end
  end
end