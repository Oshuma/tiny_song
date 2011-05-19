require 'rspec'
require "#{File.dirname(__FILE__)}/../lib/grooveshark"

RSpec.configure do |config|
  include Grooveshark
  config.mock_with :rspec
end
