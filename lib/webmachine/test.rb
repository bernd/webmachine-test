require 'forwardable'
require 'webmachine'
require 'webmachine/test/session'

module Webmachine
  # Evil monkeypatch to avoid starting the backend too early.
  # Is there something better?
  def self.run
    # NOOP
  end

  module Test
    extend Forwardable

    # Exception class for Test errors.
    class Error < StandardError
    end

    def current_session
      @session ||= Webmachine::Test::Session.new
    end

    def_delegators :current_session, :request, :header, :headers, :body, :response,
                                     :get, :post, :put, :patch, :delete,
                                     :options, :head
  end
end

