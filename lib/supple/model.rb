module Supple
  module WithClient
    extend ActiveSupport::Concern
    mattr_reader :client do
      Supple.client
    end
  end

  class Importer
    def initialize(scope, index_name, document_type)
      @scope = scope
      @index_name = index_name
      @document_type = document_type
    end

    def execute!
      @scope.find_in_batches do |batch|
        Supple.client.bulk({
          index: @index_name,
          type: @document_type,
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


  class Config
    def client
      Supple.client
    end
    def initialize(model)
      @model = model

      @index_name_method = Supple.config.index.default_index_name
      @document_type_method = Supple.config.index.default_document_type
    end

    def index_name(&block)
      @index_name_method = block if block_given?
      @index_name ||= @index_name_method.call(@model)
    end

    def document_type(&block)
      @document_type_method = block if block_given?
      @document_type ||= @document_type_method.call(@model)
    end

    def mappings(&block)
      @mappings ||= {}
      @mappings = DSL::Mapping.new(&block).to_hash if block_given?
      @mappings
    end

    def index_scope
      @model.all
    end

    def settings(data = {})
      @settings ||= {}
      @settings.merge! data
      @settings
    end


    def reindex
      alias_name = index_name
      new_index_name = alias_name + "_" + Time.now.strftime("%Y%m%d%H%M%S%L")

      document_mappings = {}
      document_mappings[document_type] = mappings
      client.indices.create index: new_index_name,
        body: {
          settings: settings,
          mappings: document_mappings
        }

      if client.indices.exists_alias(name: alias_name)
        existing_alias = client.indices.get_alias(name: alias_name)
        Importer.new(index_scope, new_index_name, document_type).execute!
        client.indices.delete index: existing_alias.keys
        client.indices.put_alias index: new_index_name, name: alias_name
      else
        client.indices.put_alias index: new_index_name, name: alias_name
        Importer.new(index_scope, new_index_name, document_type).execute!
      end

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
      after_commit lambda { es.index }, on: [:update, :create]
      after_commit lambda { es.delete }, on: :destroy
    end

    module ClassMethods
      def supple &block
        @supple ||= Supple::Config.new(self)
        @supple.instance_eval(&block) if block_given?
        @supple
      end
    end
  end
end
