$:.push File.expand_path("../lib", __FILE__)
require 'grooveshark/tiny_song'

Gem::Specification.new do |s|
  s.name = "tiny_song"
  s.version = Grooveshark::TinySong::VERSION
  s.platform = Gem::Platform::RUBY
  s.authors = ["Dale Campbell"]
  s.email = ["dale.campbell@escapemg.com"]
  s.homepage = "https://github.com/grooveshark/tiny_song"
  s.summary = "A TinySong Ruby library."
  s.description = "A TinySong Ruby library."

  s.add_dependency('json')
  s.add_development_dependency('rspec', '>= 2.6.0')

  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = ["lib"]
end
