
module FFILocale
  extend ::FFI::Library
  ffi_lib 'c'

  attach_function :strcoll, [:pointer, :pointer], :int
  attach_function :setlocale, [:int, :pointer], :string
  attach_function :strxfrm_C, :strxfrm, [:buffer_out, :string, :int], :int

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

  def self.strxfrm(src)
    length = self.strxfrm_C(nil, src, 0)
    result = ""
    FFI::MemoryPointer.new(length+1) do |dest|
      self.strxfrm_C(dest, src, length)
      result = dest.read_string
    end
    result
  end
end
