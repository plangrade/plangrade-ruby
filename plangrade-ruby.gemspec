# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'plangrade/ruby/version'

Gem::Specification.new do |spec|
  spec.name          = "plangrade-ruby"
  spec.version       = Plangrade::Ruby::VERSION
  spec.authors       = ["Plangrade Inc"]
  spec.email         = ["support@plangrade.com"]
  spec.summary       = %q{plangrade API client}
  spec.description   = %q{A ruby wrapper for accessing plangrade's REST API}
  spec.homepage      = "https://github.com/plangrade/plangrade-ruby"
  spec.licenses      = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.cert_chain    = ['certs/public.pem']
  spec.signing_key   = File.expand_path("~/.ssh/gem-private_key.pem") if $0 =~ /gem\z/

  spec.add_dependency 'oj', '~> 2.0'
  spec.add_dependency 'multi_json', '~> 1.8'
  spec.add_dependency 'rest-client', '~> 1.6'
  spec.add_dependency 'addressable', '~> 2.3'
  spec.add_dependency 'oauth2-client', '~> 2.0'

  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'simplecov', '>= 0.8'
  spec.add_development_dependency 'webmock', '>= 1.9'
  spec.add_development_dependency 'yard', '>= 0.8'
end
