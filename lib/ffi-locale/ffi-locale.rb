
module FFILocale
  extend ::FFI::Library
  ffi_lib 'c'

  attach_function :strcoll, [:pointer, :pointer], :int
  attach_function :setlocale, [:int, :pointer], :string

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
    info = self.setlocale LC_ALL, nil
    Hash[info.split(';').map { |s| name, val = s.split('='); [name.to_sym, val]}]
  end
end
