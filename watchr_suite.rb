def run_specs
  system('rake spec')
end

# Ctrl-\
Signal.trap('QUIT') do
  puts "\n--- Running all specs ---\n"
  run_specs
end

# Ctrl-C
Signal.trap('INT') { abort("\n") }

run_specs

[
  'lib/(.*/)?.*\.rb',
  'spec/(.*/)?.*_spec\.rb'
].each do |pattern|
  watch(pattern) { |md| run_specs }
end
