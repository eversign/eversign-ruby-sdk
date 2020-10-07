# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'eversign/version'

Gem::Specification.new do |spec|
  spec.name          = "eversign"
  spec.version       = Eversign::VERSION
  spec.authors       = ["Sachin Raka"]
  spec.email         = ["Sachin.Raka@outlook.com"]

  spec.summary       = %q{Gem for Eversign API Client.}
  spec.description   = %q{Gem for Eversign API SDK.}
  spec.homepage      = "https://github.com/workatbest/eversign-ruby-sdk"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = Dir['lib/**/*.rb', 'READ']      
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'rails', '>= 4'
  spec.add_dependency 'faraday', '>= 0.13'
  spec.add_dependency 'addressable', '~> 2.5'
  spec.add_dependency 'kartograph', '~> 0.2.3'
  spec.add_dependency 'configurations', '~> 2.2'

  spec.add_development_dependency 'bundler', '~> 1.12'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'simplecov'
end
