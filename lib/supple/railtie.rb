module Supple
  require 'rails'

  class Railtie < Rails::Railtie
    rake_tasks { load 'tasks/supple.rake' }
  end
end
