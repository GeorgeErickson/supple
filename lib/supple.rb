require 'elasticsearch'
require 'connection_pool'
require 'active_support/core_ext'
require 'bonfig'
require 'rails'



module Supple
  extend Bonfig

  bonfig do
    config :index do
      config :default_settings, default: {}
    end
    config :client do
      config :size, default: 5
      config :timeout, default: 1
    end
  end

  def self.models
    ActiveRecord::Base.descendants.select do |m|
      m.included_modules.include?(Supple::Model)
    end
  end

  def self.client
    @client ||= Elasticsearch::Client.new(adapter: :patron)
  end
end
require 'supple/defaults'
require 'supple/model'
# require 'supple/index'
require 'supple/railtie' if defined?(Rails)
