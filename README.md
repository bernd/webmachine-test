# Webmachine::Test

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

    class MyApp < Webmachine::Resource
      def content_types_provided
        [['text/plain', :to_text]]
      end

      def to_text
        'OK'
      end
    end

    Webmachine::Dispatcher.add_route(['*'], MyApp)
    Webmachine.run
```

### Test with RSpec

```ruby
    require 'webmachine/test'
    require 'myapp'

    describe MyApp do
      include Webmachine::Test

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
