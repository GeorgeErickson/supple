module Supple
  module WithClient
    extend ActiveSupport::Concern
    mattr_reader :client do
      Supple.client
    end
  end

  class Importer
    def initialize(scope)
      @scope = scope
    end

    def execute!
      @scope.find_in_batches do |batch|
        Supple.client.bulk {
          index: @scope.index_name,
          type: @scope.document_type,
          body: transform_batch(batch)
        }
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
      action.call {
        index: index_name,
        type: document_type,
        id: model.id,
      }.merge(extra)
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

      def import(options = {})
        Importer.new(index_scope).execute!
      end
    end
  end
end
