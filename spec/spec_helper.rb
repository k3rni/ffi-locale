begin
  require 'simplecov'
  SimpleCov.start
rescue LoadError
end
require 'ffi-locale'
require 'minitest'
require 'minitest/autorun'
