Gem::Specification.new do |s|
  s.name = 'ffi-locale'
  s.version = '1.0.0'
  s.platform = Gem::Platform::RUBY
  s.authors = `git log --format="%aN" | sort -u`.split("\n")
  s.email = 'k33rni@gmail.com'
  s.homepage = 'http://github.com/k3rni/ffi-locale'
  s.licenses = ['MIT']

  # git log --format='%aN' | sort -u
  s.summary = 'FFI wrapper over glibc locale functions'
  s.description = "Introduces C library's setlocale and strcoll functions in a thin FFI wrapper."
  s.extra_rdoc_files = [
    'LICENSE.txt',
    'README.md'
  ]
  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files {test,spec}/*`.split("\n")
  s.require_paths = ['lib']

  s.add_runtime_dependency 'ffi', '>= 1.0.7'
  s.add_development_dependency 'minitest', '>= 5.7'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'rake'
end
