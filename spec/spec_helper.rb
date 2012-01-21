require 'rubygems'
require 'bundler/setup'

require 'webmachine/test'
require 'fixtures/test_resource'

class Webmachine::Test::Session
  def app
    @app ||= Webmachine::Application.new.tap do |test_app|
      test_app.add_route(['*'], TestResource)
    end
  end
end

