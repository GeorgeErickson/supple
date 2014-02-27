# -*- encoding: utf-8 -*-

require File.expand_path('../lib/supple/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = "supple"
  gem.version       = Supple::VERSION
  gem.summary       = "An elasticsearch rails plugin"
  gem.description   = "A modern es plugin"
  gem.license       = "MIT"
  gem.authors       = ["George Erickson"]
  gem.email         = "george55@mit.edu"
  gem.homepage      = "https://rubygems.org/gems/supple"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']


  gem.add_dependency 'virtus'
  gem.add_dependency 'patron'
  gem.add_development_dependency 'bundler', '~> 1.0'
  gem.add_development_dependency 'rake', '~> 0.8'
  gem.add_development_dependency 'rspec', '~> 2.4'
  gem.add_development_dependency 'rubygems-tasks', '~> 0.2'
  gem.add_development_dependency 'yard', '~> 0.8'
end
