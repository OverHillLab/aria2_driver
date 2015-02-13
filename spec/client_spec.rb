require 'spec_helper'

module Aria2Driver
  describe Client do

    it 'should not build with explicit constructor' do
      expect{Client.new}.to raise_error(NoMethodError)
    end

    describe 'by complete jsonrpc url' do

      it 'without token' do
        client = Client.from_url('http://localhost:9090/jsonrpc')

        expect(client).not_to be_nil
      end
    end
  end
end