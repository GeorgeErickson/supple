require 'spec_helper'

describe Supple::Util do
  before(:each) do
    build_model :products do
      include Supple::Model
      string :name
    end

    5.times do
      Product.create(name: :george)
    end
  end

  describe 'Included Tracker' do
    it 'should track when the module is included' do
      expect(Supple::Model.descendants).to eq([Product])
    end

    it 'should track when the module is included' do
      expect(Supple::Model.descendants).to eq([Product])
    end
  end
end
