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
end