require 'spec_helper'

describe Supple do
  context 'registry' do
    it { expect(subject.registry).to eq([Product]) }

  end
end
