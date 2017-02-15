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
    context "without a request" do
      it "raises an exception" do
        expect { response }.to raise_error(Webmachine::Test::Error)
      end
    end

    context "with an untraceable resource" do
      before { get '/' }

      subject { response }

      it { should be_a(Webmachine::Response) }
      its(:code) { should eql(200) }
      its(:body) { should eql('OK') }
    end

    context "with a traceable resource" do
      before { get '/traceme' }

      subject { response }

      its(:code) { should eql(200) }
      its(:body) { should include('html_hi') }
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
        request.headers['Host'].should == 'localhost:80'
      end
    end

    it "accepts query parameters in the path" do
      send verb, '/?lang=en&foo=bar'
      request.query['lang'].should == 'en'
      request.query['foo'].should == 'bar'
    end

    it "accepts query parameters in the options hash" do
      send verb, '/?foo=bar', :params => {'lang' => 'en'}
      request.query['lang'].should == 'en'
      request.query['foo'].should == 'bar'
    end

    it "escapes the query parameters" do
      expect {
        send verb, '/', :params => {'test' => 'foo bar'}
      }.to_not raise_error
    end

    it "encodes the query key and value." do
      send verb, '/', :params => {"foo=" => "bar="}
      request.uri.query.should == "foo%3D=bar%3D"
    end

    it "returns the Webmachine::Request object" do
      send(verb, '/').should be_a(Webmachine::Response)
    end
  end

  describe "#get" do
    let(:verb) { 'get' }
    it_should_behave_like "a HTTP verb"
  end

  describe "#post" do
    let(:verb) { 'post' }
    it_should_behave_like "a HTTP verb"
  end

  describe "#put" do
    let(:verb) { 'put' }
    it_should_behave_like "a HTTP verb"
  end

  describe "#patch" do
    let(:verb) { 'patch' }
    it_should_behave_like "a HTTP verb"
  end

  describe "#delete" do
    let(:verb) { 'delete' }
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
    it "sets the body" do
      body('test body')
      get '/'
      request.body.should == 'test body'
    end

    it "defaults to a nil body" do
      get '/'
      request.body.should be_nil
    end
  end
  describe "#cookie" do
    it "sets a cookie" do
      cookie('SOME_COOKIE', 'VALUE')
      get '/'
      request.headers['COOKIE'].should eq('SOME_COOKIE=VALUE')
    end
    it "forwards cookies sent by the server (like a browser)" do
      get '/'
      request.headers['COOKIE'].should be_nil
      get '/'
      request.headers['COOKIE'].should eq('TEST=VALUE')
    end
    it "shows available session cookies" do
      get '/'
      session_cookies['TEST'].should eq('VALUE')
    end
  end
end
