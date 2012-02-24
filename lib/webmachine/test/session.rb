require 'stringio'

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
        @body = value.respond_to?(:read) ? value : StringIO.new(value.to_s)
      end

      HTTP_METHODS.each do |method|
        define_method method.downcase do |uri, options={}|
          do_request(method.upcase, uri, options || {})
        end
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
          q = params.map {|k, v| "#{k}=#{v}" }.join('&')
          q = URI.escape(q)

          uri.query = uri.query ? [uri.query, q].join('&') : q
        end
      end
    end
  end
end
