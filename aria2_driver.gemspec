# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'aria2_driver/version'

Gem::Specification.new do |spec|
  spec.name          = "aria2_driver"
  spec.version       = Aria2Driver::VERSION
  spec.authors       = ['Roberto Ciatti', 'Matteo Foccoli']
  spec.email         = ['info@overhilllab.com']
  spec.description   = 'Simple api to manage aria2c via api'
  spec.summary       = spec.description
  spec.homepage      = "https://github.com/OverHillLab/aria2_driver"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'json_spec'
  spec.add_development_dependency 'webmock'
end
