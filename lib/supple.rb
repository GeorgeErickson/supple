require 'elasticsearch'
require 'connection_pool'
require 'active_support/core_ext'
require 'bonfig'
require 'rails'



module Supple
  extend Bonfig

  bonfig do
    config :index do
      config :default_index_name, default: Proc.new { |model| [model.table_name, Rails.env].join('_') }
      config :default_document_type, default: Proc.new { |model| model.table_name }
    end


    config :client do
      config :host
      config :adapter, default: :patron
    end
  end

  def self.models
    ActiveRecord::Base.descendants.select do |m|
      m.included_modules.include?(Supple::Model)
    end
  end

  def self.client
    @client ||= Elasticsearch::Client.new(config.client.to_hash)
  end
end

require 'supple/model/dsl'
require 'supple/model'
require 'supple/railtie' if defined?(Rails)
