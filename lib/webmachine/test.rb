require 'forwardable'
require 'webmachine'
require 'webmachine/test/session'

module Webmachine
  module Test
    extend Forwardable

    # Exception class for Test errors.
    class Error < StandardError
    end

    def current_session
      @session ||= Webmachine::Test::Session.new(app)
    end

    def_delegators :current_session, :request, :header, :headers, :cookie, :session_cookies, :body, :response,
                                     :get, :post, :put, :patch, :delete,
                                     :options, :head
  end
end

