# Webmachine::Test

[![travis](https://secure.travis-ci.org/bernd/webmachine-test.png)](http://travis-ci.org/bernd/webmachine-test)

## WARNING

This library is still under development and incomplete!

It will be merged into [webmachine-ruby](https://github.com/seancribbs/webmachine-ruby)
when it's ready.

## Description

Webmachine::Test provides a testing API for
[webmachine-ruby](https://github.com/seancribbs/webmachine-ruby) inspired by
[rack-test](https://github.com/brynary/rack-test).

## Example Usage

### Application

```ruby
    require 'webmachine'

    class MyResource < Webmachine::Resource
      def content_types_provided
        [['text/plain', :to_text]]
      end

      def to_text
        'OK'
      end
    end

    MyApp = Webmachine::Application.new.tap do |app|
      app.add_route(['*'], MyResource)
    end

    # decouple runner from application so that adapter
    # does not start and block test thread
    #
    # MyApp.run
```

### Test with Test::Unit

```ruby
    class MyAppTest < Test::Unit::TestCase
      include Webmachine::Test

      def test_get_root_succeeds
        get '/'
        assert_equal 200, response.code
      end

      def test_get_root_replies_with_string_ok
        get '/'
        assert_equal 'OK', response.body
      end

      def test_get_root_replies_with_content_type_of_text_plain
        get '/'
        assert_equal 'text/plain', response.headers['Content-Type']
      end

      def app
        MyApp
      end
    end
```

### Test with RSpec

```ruby
    require 'webmachine/test'
    require 'myapp'

    describe MyApp do
      include Webmachine::Test

      let(:app) { MyApp }

      describe 'GET /' do
        it 'succeeds' do
          get '/'
          response.code.should == 200
        end

        it 'replies with the string OK' do
          get '/'
          response.body.should == 'OK'
        end

        it 'replies with a content type of text/plain' do
          get '/'
          response.headers['Content-Type'].should == 'text/plain'
        end
      end
    end
```
