# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "webmachine/test/version"

Gem::Specification.new do |s|
  s.name        = "webmachine-test"
  s.version     = Webmachine::Test::VERSION
  s.authors     = ["Bernd Ahlers"]
  s.email       = ["bernd@tuneafish.de"]
  s.summary     = %q{Test API for webmachine-ruby}
  s.description = <<-DESC.gsub(/\s+/, ' ')
    Webmachine::Test provides a testing API for webmachine-ruby inspired
    by rack-test.
  DESC

  s.files       = Dir['README.md', 'lib/**/*']
  s.test_files  = Dir['Gemfile', 'Rakefile', '.rspec', 'spec/**/*']

  s.add_dependency('webmachine')
  s.add_development_dependency('rake')
  s.add_development_dependency('rspec')
  s.add_development_dependency('rspec-its')
  s.add_development_dependency('bundler')
end
