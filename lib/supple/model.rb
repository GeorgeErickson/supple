module Supple
  module Model
    extend ActiveSupport::Concern
    included do
      after_commit :reindex
    end

    module ClassMethods
      def index_name
        @index_name ||= [table_name, Rails.env].join('_')
      end

      def reindex
        puts 'fuck'
      end
    end
  end
end
