require 'rake'

require 'rake/testtask'
Rake::TestTask.new(:spec) do |test|
  test.libs += %w(lib spec)
  test.pattern = 'spec/**/*.rb'
  test.verbose = true
end

task :default => :spec
