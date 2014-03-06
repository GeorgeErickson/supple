require 'elasticsearch'
require 'connection_pool'
require 'active_support/core_ext'
require 'bonfig'
require 'rails'

require 'supple/model'

module Supple
  extend Bonfig

  bonfig do
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

require 'supple/railtie' if defined?(Rails)
