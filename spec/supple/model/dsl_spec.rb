require 'spec_helper'

describe Supple::DSL::DynamicTemplate do
  subject(:dt) do
    Supple::DSL::DynamicTemplate.new(:dt_name) do
      match "taxonomy:*"
      mapping type: :nested do
        prop :id, type: :long
      end
    end
  end

  it do
   expect(dt.to_hash).to eq({
      dt_name: {
        match: "taxonomy:*",
        mapping: {
          type: :nested,
          properties: {
            id: {type: :long}
          }
        }
      }
    })
  end
end


describe Supple::DSL::Mapping do
  subject do
    mapping = Supple::DSL::Mapping.new
    mapping.instance_eval do
      prop :image_url, type: :string
      prop :name, type: :multi_field do
        prop :name, type: :string
        prop :analyzed, type: :string, analyzer: :keyword
      end
    end
    mapping
  end


  it 'handles nested mappings' do
    expect(subject.to_hash).to eq({
      properties: {
        image_url: {type: :string},
        name: {
          type: :multi_field,
          fields: {
            name: { type: :string },
            analyzed: { type: :string, analyzer: :keyword }
          }
        }
      }
    })
  end
end
