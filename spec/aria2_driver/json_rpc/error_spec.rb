require 'spec_helper'
require 'aria2_driver/json_rpc/error'

module Aria2Driver
  module JsonRpc
    describe Error do

      let :error_payload do
        {
            'code' => 25,
            'message' => 'message',
            'data' => {'data' => 'error data'}
        }
      end

      it 'should create a new error from hash' do
        error = Error.new error_payload
        expect(error).to have_attributes({
                                             code: 25,
                                             message: 'message',
                                             data: {'data' => 'error data'}
                                         })
      end
    end

  end
end