require 'supple/model/reindex'

module Supple
  module Model
    extend ActiveSupport::Concern
    include Reindex
  end
end
