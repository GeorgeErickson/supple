require 'spec_helper'

describe Supple do
  before(:each) do
    build_model :products do
      include Supple::Model
      string :name
    end
  end

  let!(:product) { Product.create(name: :george) }

  describe 'config' do
    it do
      subject.configure do |config|
        config.pool_size = 15
      end
      expect(subject.config.pool_size).to eq(15)
    end
  end

  it do
    expect(Supple::Model.descendants).to eq([Product])
  end
end
