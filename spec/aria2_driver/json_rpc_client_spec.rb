require 'spec_helper'

module Aria2Driver
  describe JsonRpcClient do

    it 'should create with defaults' do
      expect(JsonRpcClient.new 'localhost').to have_attributes(
                                                   {
                                                       scheme: 'http',
                                                       host: 'localhost',
                                                       port: 80,
                                                       path: 'jsonrpc'
                                                   })
    end

    it 'should create from url' do
      client = JsonRpcClient.from_url 'http://localhost:9090/jsonrpc'
      expect(client).not_to be_nil
      expect(client).to have_attributes({
                                            scheme: 'http',
                                            host: 'localhost',
                                            port: 9090,
                                            path: '/jsonrpc'
                                        })
    end
  end
end