require 'rake'

require 'rake/testtask'
Rake::TestTask.new(:spec) do |test|
  test.libs += %w(lib spec)
  test.pattern = 'spec/**/*.rb'
  test.verbose = true
end

task :default => :spec

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "ffi-locale #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
