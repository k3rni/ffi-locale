require 'rake'
require 'rake/testtask'
require 'bundler'

Bundler::GemHelper.install_tasks

Rake::TestTask.new(:spec) do |test|
  test.libs += %w[spec]
  test.pattern = 'spec/**/*.rb'
  test.verbose = true
end

task default: :spec

