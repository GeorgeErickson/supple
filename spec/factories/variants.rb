ActiveRecord::Migration.create_table :variants, force: true do |t|
  t.decimal 'price', precision: 8, scale: 2, default: 0.0, null: false
  t.integer 'product_id', null: false

  t.timestamps
end

class Variant < ActiveRecord::Base
  belongs_to :product, touch: true
end

FactoryGirl.define do
  factory :variant do
    price '9.99'
    product nil
  end
end
