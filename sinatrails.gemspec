# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sinatrails/version'

Gem::Specification.new do |spec|
  spec.name          = "sinatrails"
  spec.version       = Sinatrails::VERSION
  spec.authors       = ["Hugo Peixoto"]
  spec.email         = ["hugo.peixoto@gmail.com"]
  spec.summary       = %q{rails-api and sinatra integration}
  spec.description   = %q{A set of sinatra helpers to make rails-api applications work with sinatra, with as little modification as possible.}
  spec.homepage      = "https://github.com/hugopeixoto/sinatrails"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
end
