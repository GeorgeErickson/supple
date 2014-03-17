require 'spec_helper'

describe Supple do
  it do
    Supple.config do |c|
      c.client do |cl|
        cl.host = 'localhost:3000'
      end
    end
    host = Supple.client.transport.connections.first.host
    expect(host[:port]).to eq('3000')
  end
end
