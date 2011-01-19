# encoding: utf-8
require 'helper'

class TestFfiLocale < Test::Unit::TestCase
  should "report default locale" do
    info = FFILocale::getlocaleinfo
    assert_not_equal info, nil
    assert_not_equal info, {}
  end
  # NOTE: not a useful test suite. All this functionality is provided by glibc and FFI, and it's useless to
  # test libraries you depend on.
  should "return new locale after setting" do
    newlocale = FFILocale::setlocale FFILocale::LC_ALL, 'pl_PL.UTF8'
    assert_equal newlocale, 'pl_PL.UTF8'
  end
  should "collate properly" do
    letters = %w(z ś a ł t m ż o ą n ę s f ć d e ń c ź b ó l)
    FFILocale::setlocale FFILocale::LC_ALL, 'pl_PL.UTF8'
    sorted = letters.sort { |a, b| FFILocale::strcoll a, b }
    assert_equal sorted, %w(a ą b c ć d e ę f l ł m n ń o ó s ś t z ź ż)
  end
end
