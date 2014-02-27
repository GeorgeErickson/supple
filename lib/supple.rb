require 'elasticsearch'
require 'connection_pool'
require 'active_support/concern'
require 'virtus'
require 'supple/config'
require 'supple/model'

module Supple
  include Supple::Config

  module Connection
    def self.create
      ConnectionPool.new(timeout: config.pool_timeout, size: config.pool_size) do
        Elasticsearch::Client.new(adapter: :patron)
      end
    end
  end

  def self.es(&block)
    @es ||= Connection.create
    @es.with(&block)
  end
end
