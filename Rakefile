require 'rubygems'
require 'appraisal'
require 'rake'


require 'rubygems/tasks'
Gem::Tasks.new

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new

require 'elasticsearch/extensions/test/cluster/tasks'

task test: :spec
task default: :spec
