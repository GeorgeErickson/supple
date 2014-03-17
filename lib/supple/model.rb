module Supple
  module WithClient
    extend ActiveSupport::Concern
    mattr_reader :client do
      Supple.client
    end
  end

  class Importer
    def initialize(scope, index_name)
      @scope = scope
      @index_name = index_name
    end

    def execute!
      @scope.find_in_batches do |batch|
        Supple.client.bulk({
          index: @index_name,
          type: @scope.document_type,
          body: transform_batch(batch)
        })
      end
    end

    protected

    def transform_batch(batch)
       batch.map { |a| { index: { _id: a.id, data: a.as_indexed_json } } }
    end
  end


  class ModelClient
    attr_reader :model
    delegate :index_name, :document_type, :as_indexed_json, to: :model

    def initialize(model)
      @model = model
    end

    def index
      run(:index, body: as_indexed_json)
    end

    def delete
      run(:delete)
    end

    private

    def run(method, extra = {})
      action = Supple.client.method(method)
      action.call({
        index: index_name,
        type: document_type,
        id: model.id,
      }).merge(extra)
    end
  end


  module Model
    extend ActiveSupport::Concern

    def es
      @es ||= ModelClient.new(self)
    end

    def as_indexed_json
      as_json
    end


    included do
      with_options instance_writer: false do

        cattr_accessor :index_name do
          [table_name, Rails.env].join('_')
        end

        cattr_accessor :document_type do
          table_name
        end
      end

      after_commit lambda { es.index }, on: [:update, :create]
      after_commit lambda { es.delete }, on: :destroy

    end

    module ClassMethods

      def index_scope
        self.all
      end

      def reindex(options = {})
        alias_name = index_name
        new_index_name = alias_name + "_" + Time.now.strftime("%Y%m%d%H%M%S%L")
        client = Supple.client

        # TODO - Get mapping
        mappings = {}
        fields = {
          name: {type: "string", analyzer: "keyword"},
          analyzed: {type: "string", index: "analyzed"}
        }
        SETTINGS[:analysis][:analyzer].each do |name, value|
          fields[name] = {type: "string", index: "analyzed", analyzer: name}
        end



        mappings[document_type] = {
          properties: {
            name: {
              type: :multi_field,
              fields: fields,
            },
            suggest: {
              type: "completion",
              payloads: true
            },
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
        }
        # Create Index
        client.indices.create index: new_index_name,
          body: {
            settings: Supple::SETTINGS,
            mappings: mappings
          }

        if client.indices.exists_alias(name: alias_name)
          existing_alias = client.indices.get_alias(name: alias_name)
          Importer.new(index_scope, new_index_name).execute!
          client.indices.delete index: existing_alias.keys
          client.indices.put_alias index: new_index_name, name: alias_name
        else
          client.indices.put_alias index: new_index_name, name: alias_name
          Importer.new(index_scope, new_index_name).execute!
        end
      end

      private



    end
  end
end
