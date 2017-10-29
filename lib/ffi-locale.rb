# frozen-string-literal: true

require 'ffi'
require 'ffi-locale/locale.rb'

# Setup locale from environment when first loaded.
# From: http://manpages.ubuntu.com/manpages/xenial/man3/setlocale.3.html
# If locale is an empty string, "", each part of the locale that should be
# modified is set according to the environment variables. The details are
# implementation-dependent. For glibc, first (regardless of category),
# the environment variable LC_ALL is inspected, next the environment
# variable with the same name as the category (see the table above), and
# finally the environment variable LANG. The first  existing environment
# variable is used. If its value is not a valid locale specification, the
# locale is unchanged, and setlocale() returns NULL.
FFILocale.setlocale FFILocale::LC_ALL, ""
