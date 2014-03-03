source 'https://rubygems.org'

gemspec

gem 'patron'
gem 'activesupport'
gem 'connection_pool'
gem 'elasticsearch', git: 'git://github.com/elasticsearch/elasticsearch-ruby.git', branch: 'master'

group :test do
  gem 'activerecord'
  gem 'sqlite3'
  gem 'factory_girl'
end

group :development do
  gem 'kramdown'
  gem 'rspec'
  gem 'pry'
  gem 'guard'
  gem 'guard-rspec'
  gem 'guard-rubocop'
  gem 'gem-release'
end
