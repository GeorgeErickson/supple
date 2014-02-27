require 'spec_helper'
require 'supple'

describe Supple do
  describe 'config' do
    it do
      subject.configure do |config|
        config.pool_size = 15
      end

      expect(subject.config.pool_size).to eq(15)
    end
  end
end
