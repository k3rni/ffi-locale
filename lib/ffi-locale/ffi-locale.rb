
module FFILocale
  extend ::FFI::Library
  ffi_lib 'c'

  attach_function :strcoll, [:string, :string], :int
  attach_function :setlocale, [:int, :string], :string

  LC_CTYPE = 0
  LC_COLLATE = 3
  LC_ALL = 6

  def self.getlocaleinfo
    info = self.setlocale LC_ALL, nil
    Hash[info.split(';').map { |s| name, val = s.split('='); [name.to_sym, val]}]
  end
end
