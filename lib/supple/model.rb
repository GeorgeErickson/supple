module Supple
  module Client
    def es_delegate(api, action)
      define_singleton_method(action) do |*args, &block|
        Supple.client.with do |client|
          client.send(api).send(action, *args, &block)
        end
      end
    end

    def es_delegate_all(api)
      define_singleton_method(:method_missing) do |name, *args, &block|
        es_delegate(api, name)
        send(name, *args, &block)
      end
    end
  end

  module Index
    extend Client
    es_delegate_all(:indices)
  end

  module Model
    extend ActiveSupport::Concern
    included do
      after_commit :reindex
    end

    module ClassMethods
      def es_index_name
        @index_name ||= [table_name, Rails.env].join('_')
      end

      def reindex
        alias_name = es_index_name
        new_index = alias_name + '_' + Time.now.strftime('%Y%m%d%H%M%S%L')

        a = Index.get_alias(name: alias_name)
        puts a
      end
    end
  end
end
