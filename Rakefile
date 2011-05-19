require 'bundler'
require 'rspec/core/rake_task'

task :default => :spec

desc 'Run the specs'
RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = ['--color']
end

desc 'Start a console loaded with the library'
task :console do
  sh "irb -I ./lib -r 'grooveshark'"
end
