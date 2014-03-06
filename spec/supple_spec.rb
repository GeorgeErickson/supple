require 'spec_helper'

describe Supple do
  context 'registry' do
    it { expect(subject.models).to eq([Product]) }
  end

  context 'cattrs' do
    subject { Product }
    it 'defaults document_type to the table name of the model' do
      expect(Product.document_type).to eq('products')
      binding.pry
    end
  end
end
