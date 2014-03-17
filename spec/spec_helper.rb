require 'rspec'
require 'supple'
require 'active_record'
require 'sqlite3'
require 'factory_girl'
require 'elasticsearch/extensions/test/cluster'
require 'elasticsearch/extensions/test/startup_shutdown'
require 'pry' if defined?(Pry)

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: ':memory:'
)

Dir[File.dirname(__FILE__) + '/factories/*.rb'].each { |file| require file }

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods

  # config.before(:all) do
  #   Elasticsearch::Extensions::Test::Cluster.start(nodes: 1)
  #   puts 'ddddddddddddddddddddddddddddd'
  # end

  # config.after(:all) do
  #   Elasticsearch::Extensions::Test::Cluster.stop
  # end
end
