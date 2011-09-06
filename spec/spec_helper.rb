require 'rubygems'
require 'bundler/setup'

require 'webmachine/test'
require 'fixtures/test_resource'

RSpec.configure do |config|
  Webmachine::Dispatcher.add_route(['*'], TestResource)
  Webmachine.run
end
