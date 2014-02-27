module Supple
  module Model
    extend ActiveSupport::Concern

    included do
      after_commit :reindex
    end

    def reindex
      puts 'fuck'
    end

    module ClassMethods
      def es_mapping
      end

      def search
      end
    end
  end
end
