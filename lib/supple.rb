require 'elasticsearch'
require 'connection_pool'
require 'active_support/core_ext'
require 'bonfig'

require 'supple/util'
require 'supple/model'
require 'supple/tasks'

module Supple
  extend Bonfig

  bonfig do
    config :pool do
      config :size, default: 5
      config :timeout, default: 1
    end
  end

  def self.register_model(model)
    Thread.current[:registry] ||= []
    registry << model unless registry.include?(model)
  end

  def self.registry
    ActiveRecord::Base.descendants
  end
end
