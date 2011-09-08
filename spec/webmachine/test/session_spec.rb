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

  shared_examples_for "a HTTP verb" do
    it "executes a GET request" do
      send verb, '/'
      request.method.should == verb.upcase
    end

    it "sets the provided header" do
      send verb, '/', :headers => {'Accept' => 'application/x-gunzip'}
      request.headers['Accept'].should == 'application/x-gunzip'
    end

    context "with a complete URI" do
      it "sets the correct host header" do
        send verb, 'http://example.com:3000/foo'
        request.headers['Host'].should == 'example.com:3000'
      end
    end

    context "with an incomplete URI" do
      it "sets the correct host header" do
        send verb, '/foo'
        request.headers['Host'].should == 'localhost'
      end
    end

    it "accepts query parameters in the path" do
      send verb,'/?lang=en&foo=bar'
      request.query['lang'].should == 'en'
      request.query['foo'].should == 'bar'
    end

    it "accepts query parameters in the options hash" do
      send verb, '/?foo=bar', :params => {'lang' => 'en'}
      request.query['lang'].should == 'en'
      request.query['foo'].should == 'bar'
    end
  end

  describe "#get" do
    let(:verb) { 'get' }
    it_should_behave_like "a HTTP verb"
  end

  describe "#head" do
    let(:verb) { 'head' }
    it_should_behave_like "a HTTP verb"
  end

  describe "#options" do
    let(:verb) { 'options' }
    it_should_behave_like "a HTTP verb"
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
