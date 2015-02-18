require 'spec_helper'

module Aria2Driver
  module JsonRpc
    describe Client do

      it 'should create with defaults' do
        client = Aria2Driver::JsonRpc::Client.new 'localhost', {id: 'my'}
        expect(client).not_to be_nil
        expect(client.id).to eq('my')
        expect(client.connection).to have_attributes({
                                                         scheme: Aria2Driver::JsonRpc::Connection::DEFAULTS[:scheme],
                                                         host: 'localhost',
                                                         port: Aria2Driver::JsonRpc::Connection::DEFAULTS[:port]
                                                     })
      end



      it 'should create from url' do
        client = Aria2Driver::JsonRpc::Client.from_url 'https://localhost:9090/jsonrpc'
        expect(client).not_to be_nil
        expect(client.connection).to have_attributes({
                                                         scheme: 'https',
                                                         host: 'localhost',
                                                         port: 9090
                                                     })
      end

      it 'should set token' do
        client = Aria2Driver::JsonRpc::Client.from_url 'https://localhost:9090/jsonrpc', token: 'abcd-1234'
        expect(client.token).to eq('abcd-1234')
      end

    end
  end
end