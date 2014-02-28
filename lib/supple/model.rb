require 'active_support/descendants_tracker'

module Supple
  module Model
    extend ActiveSupport::Concern


    included do
      after_commit :reindex
      ActiveSupport::DescendantsTracker.store_inherited(Supple::Model, self)
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
