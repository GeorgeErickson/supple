module Supple
  require 'rails'

  class Railtie < ::Rails::Railtie
    rake_tasks { load 'tasks/supple.rake' }
    initializer "supple" do
      puts 'initializer'
    end
    config.after_initialize do
      puts 'After Init'
    end
  end
end
