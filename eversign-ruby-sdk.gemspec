# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'eversign/version'

Gem::Specification.new do |spec|
  spec.name          = "eversign-sdk"
  spec.version       = Eversign::VERSION
  spec.authors       = ["eversign"]
  spec.email         = ["support@eversign.com"]

  spec.summary       = %q{Gem for Eversign API Client.}
  spec.description   = %q{Gem for Eversign API SDK.}
  spec.homepage      = "https://github.com/workatbest/eversign-ruby-sdk"
  spec.license       = "MIT"

  spec.files         = Dir['lib/**/*.rb', 'READ']      
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'rails', '>= 4'
  spec.add_dependency 'faraday', '>= 0.13'
  spec.add_dependency 'addressable', '~> 2.5'
  spec.add_dependency 'kartograph', '~> 0.2.3'
  spec.add_dependency 'configurations', '~> 2.2'

  spec.add_development_dependency 'bundler', '~> 2'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'dotenv-rails'

end
