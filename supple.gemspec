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


  gem.add_dependency 'patron'
  gem.add_dependency 'ansi'
  gem.add_dependency 'bonfig'
  gem.add_dependency 'elasticsearch'
  gem.add_dependency 'connection_pool'
  gem.add_development_dependency 'bundler'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'rubygems-tasks'
  gem.add_development_dependency 'yard'
  gem.add_development_dependency 'appraisal'
  gem.add_development_dependency 'sqlite3'
  gem.add_development_dependency 'factory_girl'
  gem.add_development_dependency 'elasticsearch-extensions'
end
