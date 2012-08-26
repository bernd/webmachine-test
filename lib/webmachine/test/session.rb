require 'stringio'
require 'uri'

# Ruby 1.8 does not have URI.encode_www_form_component.
unless URI.respond_to?(:encode_www_form_component)
  require 'webmachine/test/backports/uri'
end

module Webmachine
  module Test
    class Session
      HTTP_METHODS = %W(HEAD GET PUT POST PATCH DELETE OPTIONS)

      def initialize(app)
        @headers = Webmachine::Headers.new
        @body = nil
        @req = nil
        @res = nil
        @app = app
      end

      # Returns the request object.
      def request
        @req || webmachine_test_error('No request object yet. Issue a request first.')
      end

      # Returns the response object after a request has been made.
      def response
        @res || webmachine_test_error('No response yet. Issue a request first!')
      end

      # Set a single header for the next request.
      def header(name, value)
        @headers[name] = value
      end

      # Set the request body.
      def body(value)
        @body = value
      end

      HTTP_METHODS.each do |method|
        class_eval <<-__RUBY
          def #{method.downcase}(uri, options = {})
            do_request('#{method.upcase}', uri, options)
          end
        __RUBY
      end

      private
      def webmachine_test_error(msg)
        raise Webmachine::Test::Error.new(msg)
      end

      def do_request(method, uri, options)
        uri = URI.parse(uri)
        uri.scheme ||= 'http'
        uri.host ||= 'localhost'

        add_query_params(uri, options[:params])

        # Set some default headers and merge the provided ones.
        @headers['Host'] = [uri.host, uri.port].compact.join(':') unless @headers['Host']
        @headers['Accept'] = '*/*' unless @headers['Accept']

        options[:headers] ||= {}
        options[:headers].each { |k, v| @headers[k] = v }

        @body ||= options[:body] || StringIO.new

        @req = Webmachine::Request.new(method, uri, @headers, @body)
        @res = Webmachine::Response.new

        @app.dispatcher.dispatch(@req, @res)
        return @res
      end

      def add_query_params(uri, params)
        if params
          q = params.map do |k, v|
            k, v = URI.encode_www_form_component(k), URI.encode_www_form_component(v)
            "#{k}=#{v}"
          end.join('&')

          uri.query = uri.query ? [uri.query, q].join('&') : q
        end
      end
    end
  end
end
