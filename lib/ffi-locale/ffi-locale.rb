module FFILocale
  extend ::FFI::Library
  ffi_lib 'c'

  attach_function :strcoll, [:pointer, :pointer], :int
  attach_function :setlocale, [:int, :pointer], :string
  attach_function :strxfrm_C, :strxfrm, [:buffer_out, :string, :int], :int

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

  def self.getlocaleinfo
    info = setlocale LC_ALL, nil
    locale_hash(info)
  end

  def self.strxfrm(src)
    length = strxfrm_C(nil, src, 0)
    result = ""
    FFI::MemoryPointer.new(length+1) do |dest|
      strxfrm_C(dest, src, length)
      result = dest.read_string
    end
    result
  end

  private

  def self.locale_hash(info)
    if info =~ /(LC_[A-Z]+=.*(?:;|$))+/
      Hash[info.split(';').map do |pair|
        name, val = pair.split('=')
        [name.to_sym, val]
      end]
    else
      # When the process environment didn't have any LC_ variables set, setlocale
      # might return a plain locale name. In this case use it for every setting.
      Hash[self.constants.map do |lc|
        [lc.to_sym, info]
      end]
    end
  end
end
