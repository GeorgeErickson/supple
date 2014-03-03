require 'rake'

namespace :supple do
  namespace :reindex do
    desc 'reindex all models'

    task all: :environment do
      Rails.application.eager_load! if defined?(Rails)
      Supple.models.each do |model|
        puts 1
        puts model
      end
    end
  end
end
