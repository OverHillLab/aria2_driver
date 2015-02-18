require 'spec_helper'

module Aria2Driver
  module JsonRpc
    describe Connection do
      it 'should create a new connection with defaults parameters' do
        conn = Connection.new 'localhost'
        expect(conn).to have_attributes({
                                            scheme: 'http',
                                            host: 'localhost',
                                            port: 80
                                        })
      end

      it 'should override defaults' do
        conn = Connection.new 'example', {scheme: 'https', host: 'example', port: 9090}
        expect(conn).to have_attributes({
                                            scheme: 'https',
                                            host: 'example',
                                            port: 9090
                                        })
      end
    end
  end
end