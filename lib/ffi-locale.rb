require 'ffi'
require 'ffi-locale/ffi-locale.rb'

# Setup locale from environment when first loaded.
# See http://pubs.opengroup.org/onlinepubs/007908799/xbd/envvar.html#tag_002_002
ENV.select { |key, value| key =~ /^LC_/ }.each do |key, value|
  FFILocale::setlocale FFILocale.const_get(key), value
end
