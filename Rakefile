require 'bundler'
require 'rake/rdoctask'
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

namespace :docs do
  Rake::RDocTask.new do |rd|
    rd.title = "TinySong API"
    rd.main = "README.rdoc"
    rd.rdoc_dir = "#{File.dirname(__FILE__)}/doc/api"
    rd.rdoc_files.include("README.rdoc", "lib/**/*.rb")
    rd.options << "--all"
  end
end

desc 'Build the API docs'
task :docs do
  Rake::Task['docs:rerdoc'].invoke
  STDOUT.puts "Copying Javascript files..."
  doc_root = "#{File.dirname(__FILE__)}/doc"
  system("cp -r #{doc_root}/js #{doc_root}/api/")
end
