module Supple
  class IndexConfig < BasicObject
  end
  class Index
    include ActiveSupport::DescendantsTracker

    def self.settings(data = nil)
      @settings = data unless data.nil?
      @settings
    end

    def self.mappings(data = nil)
      @mappings = data unless data.nil?
      @mappings
    end


    with_options instance_writer: false do
      cattr_accessor :model do
        binding.pry
      end
      cattr_accessor :index_name do
        [table_name, Rails.env].join('_')
      end

      cattr_accessor :document_type do
        table_name
      end
    end
  end
end
