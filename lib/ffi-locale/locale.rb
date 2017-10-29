# frozen-string-literal: true

# Wrap some libc's locale functions.
module FFILocale
  extend ::FFI::Library
  ffi_lib 'c'

  attach_function :strcoll, %i[pointer pointer], :int
  attach_function :setlocale, %i[int pointer], :string
  attach_function :strxfrm_C, :strxfrm, %i[buffer_out string int], :int

  # NOTE: these values are taken from /usr/include/locale.h on Ubuntu Linux
  # No guarantees they are the same on other OS'es or non-glibc systems.
  LC_CTYPE,
  LC_NUMERIC,
  LC_TIME,
  LC_COLLATE,
  LC_MONETARY,
  LC_MESSAGES,
  LC_ALL,
  LC_PAPER,
  LC_NAME,
  LC_ADDRESS,
  LC_TELEPHONE,
  LC_MEASUREMENT,
  LC_IDENTIFICATION = (0..12).to_a

  module_function

  # Fetch current locale settings.
  # @return [String] current locale code, as set with LC_ALL
  # @see https://www.gnu.org/software/libc/manual/html_node/Setting-the-Locale.html
  def getlocaleinfo
    info = setlocale LC_ALL, nil
    locale_hash(info)
  end

  # Transform a string into a form suitable for locale-sensitive sorting. Use with
  # {Enumerable.sort_by}, this improves performance over using {strcoll} each time.
  # @see https://www.gnu.org/software/libc/manual/html_node/Collation-Functions.html#index-strxfrm
  # @param src [String] input string
  # @return [String] transformed output
  def strxfrm(src)
    length = strxfrm_C(nil, src, 0) # Find out buffer size needed to store output
    FFI::MemoryPointer.new(length + 1) do |dest|
      strxfrm_C(dest, src, length)
      return dest.read_string
    end
  end

  # Parse list of locale settings, returns a hash of locale_category => current setting
  def locale_hash(info)
    if info =~ /(LC_[A-Z]+=.*(?:;|$))+/
      Hash[info.split(';').map do |pair|
        name, val = pair.split('=')
        [name.to_sym, val]
      end]
    else
      # When the process environment didn't have any LC_ variables set, setlocale
      # might return a plain locale name. In this case use it for every setting.
      Hash[constants.map do |lc|
        [lc.to_sym, info]
      end]
    end
  end

  private_class_method :locale_hash
end
