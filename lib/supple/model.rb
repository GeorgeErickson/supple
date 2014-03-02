require 'supple/model/reindex'

module Supple
  module Model
    extend ActiveSupport::Concern
    # extend Util::IncludedTracker
    include Reindex

    def self.descendants
      Rails.application.eager_load! if defined?(Rails)
      ActiveSupport::DescendantsTracker.descendants(self)
    end

    included do
      ActiveSupport::DescendantsTracker.store_inherited(Supple::Model, self)
    end
  end
end
