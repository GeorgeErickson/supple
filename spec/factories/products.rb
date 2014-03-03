ActiveRecord::Migration.create_table :products, force: true do |t|
  t.string :name
  t.string :color

  t.timestamps
end

class Product < ActiveRecord::Base
  include Supple::Model
  has_many :variants
end

FactoryGirl.define do
  sequence(:product_name) { |n| "Product#{n}" }
  factory :product do
    name { generate(:product_name) }

    ignore do
      variants_count 2
    end

    after(:create) do |product, evaluator|
      FactoryGirl.create_list(:variant, evaluator.variants_count, product: product)
    end
  end
end
