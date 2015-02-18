require 'spec_helper'

module Aria2Driver
  module JsonRpc
    describe Connection do
      it 'should create a new connection with defaults parameters' do
        conn = Connection.new 'localhost'
        expect(conn).not_to be_nil
      end
    end
  end
end