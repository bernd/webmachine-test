require 'webmachine/headers'
require 'uri'
require 'webmachine/request'
require 'webmachine/response'

module Webmachine
  module Test
    class Session
      HTTP_METHODS = %W(HEAD GET PUT POST PATCH DELETE OPTIONS)

      def initialize(app)
        @headers = Webmachine::Headers.new
        @session_cookies = {}
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

      def cookie(name, value)
        @session_cookies[name] = value
      end

      def session_cookies
        @session_cookies
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
        uri = "http://localhost#{uri}" unless uri =~ %r(^https?://)
        uri = URI.parse(uri)

        add_query_params(uri, options[:params])

        # Set some default headers and merge the provided ones.
        @headers['Host'] ||= [uri.host, uri.port].compact.join(':')
        @headers['Accept'] ||= '*/*'
        @headers['Origin'] ||= @headers['Host']
        add_cookies

        options[:headers] ||= {}
        options[:headers].each { |k, v| @headers[k] = v }


        @body ||= options[:body]

        @req = Webmachine::Request.new(method, uri, @headers, @body)
        @res = Webmachine::Response.new

        @app.dispatcher.dispatch(@req, @res)
        update_session_cookies
        return @res
      end

      def update_session_cookies
        if @res.headers['Set-Cookie']
          @res.headers['Set-Cookie'].reduce(@session_cookies) do |cookies, c|
            cookie_info = c.split(';')
            kv = Webmachine::Cookie.parse(cookie_info.shift)
            cname = kv.keys.first
            cval = kv.values.first
            cookie = cookie_info.map(&:strip).reduce({value: cval}) do |cookie, part|
              case part
              when 'Secure'
                cookie[:secure] = true
              when 'HttpOnly'
                cookie[:http_only] = true
              when /Expires=(?<date>.*)/
                cookie[:expires] = Time.parse($~[:date])
              end
              cookie
            end
            if cookie[:value].nil? or (cookie[:expires] and cookie[:expires] < Time.now)
              cookies.delete cname
            else
              cookies.merge!({cname => cval})
            end
            cookies
          end
        end
      end

      def add_query_params(uri, params)
        if params
          q = URI.encode_www_form(params)
          uri.query = uri.query ? [uri.query, q].join('&') : q
        end
      end

      def add_cookies
        as_strings = @session_cookies.map do |k,v|
          "#{k}=#{v}"
        end
        cookies = as_strings.join("; ")
        @headers['Cookie'] = cookies unless cookies.empty?
      end
    end
  end
end
