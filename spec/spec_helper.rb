if RUBY_ENGINE == "rbx"
  require "codeclimate-test-reporter"
  CodeClimate::TestReporter.start
end

require 'json_spec'
require 'webmock/rspec'

require 'aria2_driver'

RSpec.configure do |config|
  config.include JsonSpec::Helpers
  config.mock_with :rspec

# Re-Enable connection to codeclimate to post coverage report
  config.after(:suite) do
    WebMock.disable_net_connect!(:allow => 'codeclimate.com')
  end
end