require 'bundler/gem_tasks'
require 'rake'
require 'rspec/core'
require 'rspec/core/rake_task'
require 'octorelease'
require 'rubocop/rake_task'
RSpec::Core::RakeTask.new(:spec)
RuboCop::RakeTask.new

task default: %i(spec rubocop)
