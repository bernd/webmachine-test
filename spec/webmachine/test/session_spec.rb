require 'spec_helper'

describe Webmachine::Test::Session do
  include Webmachine::Test

  describe "#request" do
    it "returns the Webmachine::Request object" do
      get '/'
      request.should be_a(Webmachine::Request)
    end

    context "without a request" do
      it "raises an exception" do
        expect { request }.to raise_error(Webmachine::Test::Error)
      end
    end
  end

  describe "#response" do
    it "returns the Webmachine::Response object" do
      get '/'
      response.should be_a(Webmachine::Response)
    end

    context "without a request" do
      it "raises an exception" do
        expect { response }.to raise_error(Webmachine::Test::Error)
      end
    end
  end

  describe "#get" do
    it "issues a GET request" do
      get '/'
      request.method.should == 'GET'
    end

    it "sets the provided header" do
      get '/', :headers => {'Accept' => 'application/x-gunzip'}
      request.headers['Accept'].should == 'application/x-gunzip'
    end

    context "with a complete URI" do
      it "sets the correct host header" do
        get 'http://example.com:3000/foo'
        request.headers['Host'].should == 'example.com:3000'
      end
    end

    context "with an incomplete URI" do
      it "sets the correct host header" do
        get '/foo'
        request.headers['Host'].should == 'localhost'
      end
    end

    it "accepts query parameters in the path" do
      get '/?lang=en&foo=bar'
      request.query['lang'].should == 'en'
      request.query['foo'].should == 'bar'
    end

    it "accepts query parameters in the options hash" do
      get '/?foo=bar', :params => {'lang' => 'en'}
      request.query['lang'].should == 'en'
      request.query['foo'].should == 'bar'
    end
  end

  describe "#header" do
    it "sets the given header value" do
      header('Foo', 'bar-baz')
      get '/'
      request.headers['Foo'].should == 'bar-baz'
    end
  end

  describe "#body" do
    context "given a string" do
      it "sets the body" do
        body('test body')
        get '/'
        request.body.read.should == 'test body'
      end
    end

    context "given an IO object" do
      it "sets the body" do
        body(StringIO.new('foo'))
        get '/'
        request.body.read.should == 'foo'
      end
    end
  end
end
