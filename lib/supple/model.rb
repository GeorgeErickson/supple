require 'supple/model/reindex'

module Supple
  module Model
    extend ActiveSupport::Concern
    include Reindex

    included do
      Supple.register_model(self)
    end
  end
end
