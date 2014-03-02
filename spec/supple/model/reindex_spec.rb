require 'spec_helper'

describe Supple do
  before(:each) do
    build_model :products do
      include Supple::Model
      string :name
    end
  end

  describe 'index_name' do
    it 'defaults to a combination of the table name and environment' do
      # expect(Product.index_name).to eq('products_developement')
    end
  end
end
