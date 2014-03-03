require 'rspec'
require 'supple'
require 'active_record'
require 'sqlite3'
require 'factory_girl'
require 'pry'

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: ':memory:'
)

Dir[File.dirname(__FILE__) + '/factories/*.rb'].each { |file| require file }

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
end
