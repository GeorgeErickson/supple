module Supple
  module Config
    extend ActiveSupport::Concern
    class Base
      include Virtus.model

      attribute :pool_size, Integer, default: 5
      attribute :pool_timeout, Integer, default: 1
    end

    module ClassMethods
      def config
        @config ||= Supple::Config::Base.new
      end

      def configure
        yield config
      end
    end
  end
end
