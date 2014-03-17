require 'spec_helper'

class ProductSearch < Supple::Index
  settings number_of_shards: 1, number_of_replicas: 0
  mappings do
    property do
    end
  end
  mappings({
    properties: {
      variants: {
        type: "nested",
        properties: {
          id: {type: "long"},
          price: {type: "long"}
        }
      }
    },
    dynamic_templates: [{
      nested_taxonomies: {
        match: "taxonomy:*",
        mapping: {
          type: :nested,
          properties: {
            name: {
              type: :string,
              analyzer: :keyword
            }
          }
        }
      }
    }]
  })

end

describe Supple::Index do
  subject { ProductSearch }

  it do
    expect(ProductSearch.settings).to eq({number_of_shards: 1, number_of_replicas: 0})
  end

  it do
    expect(ProductSearch.mappings).to eq({name: 1, number_of_replicas: 0})
  end
end
