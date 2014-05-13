# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'statsd/rack/version'

Gem::Specification.new do |spec|
  spec.name          = "statsd-rack"
  spec.version       = Statsd::Rack::VERSION
  spec.authors       = ["Raghuram Sreenath"]
  spec.email         = ["raghums@gmail.com"]
  spec.description   = %q{Initialize a statsd client that is optionally namespaced. By default pumps request and GC metrics.}
  spec.homepage      = "http://github.com/raghums/statsd-rack"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "statsd-ruby"
end
