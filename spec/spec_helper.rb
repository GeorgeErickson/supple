require 'rspec'
require 'supple'
require 'active_record'
require 'sqlite3'
require 'pry'

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: ':memory:'
)

ActiveRecord::Migration.create_table :products, force: true do |t|
  t.string :name
  t.string :color

  t.timestamps
end

ActiveRecord::Migration.create_table :variants, force: true do |t|
  t.decimal 'price', precision: 8, scale: 2, default: 0.0, null: false
  t.integer 'product_id', null: false

  t.timestamps
end

class Product < ActiveRecord::Base
  include Supple::Model
end
