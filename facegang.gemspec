# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'facegang/version'
require 'rubygems'

Gem::Specification.new do |spec|
  spec.name          = "facegang"
  spec.version       = Facegang::VERSION
  spec.authors       = ["Thomas Graves"]
  spec.email         = ["pythonbabe@gmail.com"]
  spec.summary       = "Collection of Facebook E-whoring Tools"
  spec.description   = "Facebook E-Whoring"
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency('rdoc')
  spec.add_development_dependency('aruba')
  spec.add_development_dependency('rake', '~> 0.9.2')
  spec.add_dependency('methadone', '~> 1.4.0')
  spec.add_development_dependency('rspec')

  # Added custom dependencies
  spec.add_development_dependency('koala')
  spec.add_development_dependency('xmpp4r')
  spec.add_development_dependency('xmpp4r_facebook')
  spec.add_development_dependency('capybara')
  spec.add_development_dependency('poltergeist')
  spec.add_development_dependency('selenium-webdriver')
  # Added custom testing dependencies
  spec.add_development_dependency('shoulda-matchers')
  spec.add_development_dependency('factory_girl')
  spec.add_development_dependency('faker')
end
