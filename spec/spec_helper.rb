if RUBY_ENGINE == "rbx"
  require "codeclimate-test-reporter"
  CodeClimate::TestReporter.start
end

require 'aria2_driver'

RSpec.configure do |config|
  config.mock_with :rspec
end