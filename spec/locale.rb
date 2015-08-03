# encoding: utf-8
require 'spec_helper'

describe 'FFILocale' do
  # NOTE: not a useful test suite. All this functionality is provided by glibc and FFI, and it's useless to
  # test libraries you depend on.
  let(:locale_keys) do
    [:LC_CTYPE, :LC_COLLATE, :LC_MESSAGES]
  end
  let(:alphabet_pl) { %w(a ą b c ć d e ę f l ł m n ń o ó s ś t z ź ż) }
  let(:names) { %w(Ágnes Andor Cecil Cvi Csaba Elemér Éva Géza Gizella György Győző Lóránd Lotár Lőrinc Lukács Orsolya Ödön Ulrika Üllő) }

  specify 'report default locale' do
    info = FFILocale.getlocaleinfo
    info.wont_be_nil
    info.must_be_kind_of(Hash)
    locale_keys.each do |key|
      info.must_include key
    end
  end

  specify 'return new locale after setting' do
    newlocale = FFILocale.setlocale FFILocale::LC_ALL, 'pl_PL.UTF-8'
    newlocale.must_equal('pl_PL.UTF-8')
  end

  specify 'know the Polish ABC' do
    letters = %w(z ś a ł t m ż o ą n ę s f ć d e ń c ź b ó l)
    FFILocale.setlocale FFILocale::LC_ALL, 'pl_PL.UTF-8'
    sorted = letters.sort { |a, b| FFILocale.strcoll a, b }
    sorted.must_equal(alphabet_pl)
  end

  specify 'perform sorting by collation' do
    FFILocale.setlocale FFILocale::LC_COLLATE, 'hu_HU.UTF-8'
    sorted = names.dup.shuffle.sort_by { |s| FFILocale.strxfrm(s) }
    sorted.must_equal(names)
  end
end
