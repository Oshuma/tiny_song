require 'spec'
require "#{File.dirname(__FILE__)}/../lib/grooveshark"

Spec::Runner.configure do |config|
  include Grooveshark
end
