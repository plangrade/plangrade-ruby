# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'plangrade/ruby/version'

Gem::Specification.new do |spec|
  spec.name          = "plangrade-ruby"
  spec.version       = Plangrade::Ruby::VERSION
  spec.authors       = ["Christopher Reynoso"]
  spec.email         = ["topherreynoso@gmail.com"]
  spec.summary       = %q{plangrade API client}
  spec.description   = %q{A ruby wrapper for accessing plangrade's REST API}
  spec.homepage      = "https://github.com/topherreynoso/plangrade-ruby"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.cert_chain    = ['certs/public.pem']
  spec.signing_key   = File.expand_path("~/.ssh/gem-private_key.pem") if $0 =~ /gem\z/

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "vcr"
  spec.add_development_dependency "webmock"

  spec.add_dependency "faraday"
  spec.add_dependency "json"
  spec.add_dependency 'oj', '~> 2.0'
  spec.add_dependency 'multi_json', '~> 1.8'
  spec.add_dependency 'rest-client', '~> 1.6'
  spec.add_dependency 'addressable', '~> 2.3'
  spec.add_dependency 'oauth2-client', '~> 2.0'

  spec.post_install_message = %q{ Thanks for installing! For API help go to http://docs.plangrade.com }
end
