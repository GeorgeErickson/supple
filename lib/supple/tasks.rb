require 'rake'

namespace :supple do
  namespace :reindex do
    desc 'reindex all models'

    task all: :environment do
      Rails.application.eager_load! if defined?(Rails)
      ActiveRecord::Base.descendants.each do |model|
        puts model
      end
    end
  end
end
