# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "version"

Gem::Specification.new do |s|
  s.name        = "dboard"
  s.version     = Dboard::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Joakim Kolsjö"]
  s.email       = ["joakim.kolsjo@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Dashboard framework}
  s.description = %q{Dashboard framework}
  s.license     = "MIT"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {spec}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "httparty", "~> 0.7.8"
  s.add_dependency "rake", "~> 0.9.2"
  s.add_dependency "json", "~> 1.4.6"
  s.add_dependency "dalli", "~> 1.0.5"
  s.add_dependency "sinatra", "~> 1.2"
  s.add_development_dependency "rspec", "2.6.0"
end
