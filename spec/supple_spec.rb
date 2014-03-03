require 'spec_helper'

describe Supple do
  context 'registry' do
    it { expect(subject.models).to eq([Product]) }
  end
end
