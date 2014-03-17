require 'elasticsearch'
require 'connection_pool'
require 'active_support/core_ext'
require 'bonfig'
require 'rails'



module Supple
  extend Bonfig

  bonfig do
    config :host
    config :index do
      config :default_index_name, default: Proc.new { |model| [model.table_name, Rails.env].join('_') }
      config :default_document_type, default: Proc.new { |model| model.table_name }
    end
  end

  def self.models
    ActiveRecord::Base.descendants.select do |m|
      m.included_modules.include?(Supple::Model)
    end
  end
  def self.client!
    Elasticsearch::Client.new(host: Supple.config.host)
  end

  def self.client
    client!
  end

  def self.refresh_connection!
    @client = Elasticsearch::Client.new(host: Supple.config.host)
  end
end

require 'supple/model/dsl'
require 'supple/model'
require 'supple/railtie' if defined?(Rails)
