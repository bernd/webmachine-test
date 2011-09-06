# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "webmachine/test/version"

Gem::Specification.new do |s|
  s.name        = "webmachine-test"
  s.version     = Webmachine::Test::VERSION
  s.authors     = ["Bernd Ahlers"]
  s.email       = ["bernd@tuneafish.de"]
  s.homepage    = ""
  s.summary     = %q{Test API for webmachine-ruby}
  s.description = <<-DESC.gsub(/\s+/, ' ')
    Webmachine::Test provides a testing API for webmachine-ruby inspired
    by rack-test.
  DESC

  s.rubyforge_project = "webmachine-test"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<webmachine>)
    else
      s.add_dependency(%q<webmachine>)
    end
  else
    s.add_dependency(%q<webmachine>)
  end
end
