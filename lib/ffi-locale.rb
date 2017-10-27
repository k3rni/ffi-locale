require 'ffi'
require 'ffi-locale/ffi-locale.rb'

# Setup locale from environment when first loaded.
FFILocale::setlocale FFILocale.const_get("LC_ALL"), ""
