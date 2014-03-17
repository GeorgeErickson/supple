require 'spec_helper'

class Product
  supple do

    # settings number_of_shards: 1, number_of_replicas: 0 do
    #   analyzer type: :custom do
    #     tokenizer 'standard'
    #     filter :lowercase, :asciifolding
    #   end
    # end
    mappings do
      dynamic_template :dt_1 do
        match "dt:*"
        mapping type: :nested do
          prop :name, type: :string
        end
      end
      prop :id, type: :long
    end
  end
end

describe Supple::Config do
  context 'index_name' do
    it 'defaults to config.index_name_method' do
      expect(Product.supple.index_name).to eq('products_development')
    end

    it 'can be overritten' do
      m = Class.new(ActiveRecord::Base) do
        include Supple::Model
        supple do
          index_name do |model|
            model.name
          end
        end

        def self.name
          'test'
        end
      end

      expect(m.supple.index_name).to eq('test')
    end
  end
end
describe Product do

  it do
   data = Product.supple.mappings
   puts data
  end
end

