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

  def self.models
    ActiveRecord::Base.descendants.select do |m|
      m.included_modules.include?(Supple::Model)
    end
  end
end
