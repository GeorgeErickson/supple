require 'spec_helper'
require 'active_record'
require 'sqlite3'
require 'supple'
require 'factory_girl'
require 'pry'




ActiveRecord::Base.default_timezone = :utc
ActiveRecord::Base.time_zone_aware_attributes = true
ActiveRecord::Base.establish_connection :adapter => "sqlite3", :database => ":memory:"




class DefaultCreator < ActiveRecord::Base
  def initialize(*args)
    binding.pry
  end
end

FactoryGirl.define do

  factory :user, class: DefaultCreator do
    name 'John Doe'
    date_of_birth 21

    initialize_with do
      new(attributes)
    end
  end
end
RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
end

ActiveRecord::Migration.create_table :products, :force => true do |t|
  t.string :name
  t.integer :store_id
  t.boolean :in_stock
  t.boolean :backordered
  t.integer :orders_count
  t.integer :price
  t.string :color
  t.decimal :latitude, precision: 10, scale: 7
  t.decimal :longitude, precision: 10, scale: 7
  t.timestamps
end

describe Supple do
  describe 'config' do
    it do
      subject.configure do |config|
        config.pool_size = 15
      end

      expect(subject.config.pool_size).to eq(15)
    end
  end

  it do
    create :user
  end
end
