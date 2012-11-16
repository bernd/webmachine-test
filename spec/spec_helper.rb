require 'rubygems'
require 'bundler/setup'

require 'webmachine/application'
require 'webmachine/test'
require 'webmachine'

require 'fixtures/test_resource'
require 'fixtures/traceable_resource'

module WebmachineTestApplication
  def app
    @app ||= Webmachine::Application.new do |test_app|
      test_app.routes do
        add ['traceme'], TraceableResource
        add ['*'], TestResource
      end
    end
  end
end

RSpec.configure do |c|
  c.include WebmachineTestApplication
end

