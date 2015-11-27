ffi-locale
==========

A small gem to aid with locale-sensitive string comparison (collation), which ruby lacks by default. Roughly based on
Matz' [rather ancient code](http://www.justskins.com/forums/ruby-talk-newbie-locale-8419.html). 
However, instead of creating a wrapper around these functions, I call them using FFI.

[![Build Status](https://travis-ci.org/k3rni/ffi-locale.svg)](https://travis-ci.org/k3rni/ffi-locale) [![Dependency Status](https://gemnasium.com/k3rni/ffi-locale.svg)](https://gemnasium.com/k3rni/ffi-locale) [![Inline docs](http://inch-ci.org/github/k3rni/ffi-locale.svg?branch=master)](http://inch-ci.org/github/k3rni/ffi-locale)

Scope
-----

Everything this library does could be accomplished by adding two functions to [ffi-libc](https://github.com/postmodern/ffi-libc).
However, I didn't need any of the extra bindings ffi-libc would bring, and decided to separate the functionality.

The library offers only 4 functions, all of them thin wrappers over libc functionality:

* [strcoll](http://www.gnu.org/software/libc/manual/html_node/Collation-Functions.html)
* [strxfrm](http://www.gnu.org/software/libc/manual/html_node/Collation-Functions.html)
* [setlocale](http://www.gnu.org/software/libc/manual/html_node/Setting-the-Locale.html)
* getlocaleinfo, built on top of setlocale

Audience
--------

You don't need ffi-locale if you:

* are using your ORM & RDBMS to sort strings - [both](http://www.postgresql.org/docs/9.2/static/collation.html) [major](http://dev.mysql.com/doc/refman/5.0/en/charset-table.html) opensource DBs have had good or decent support for years
* will only ever be using [ASCII](https://github.com/pda/roflbalt)
* think [i18n](http://github.com/svenfuchs/i18n) is only about translating some messages

You need ffi-locale if you:

* are OCD about [proper sorting](http://www.unicode.org/reports/tr10/)
* process messy textual data from third-party sources
* keep your strings in a [byte-oriented](http://redis.io/) or otherwise [localization-oblivious](http://docs.mongodb.org/manual/core/document/#string) storage

Alternatives
------------

* [twitter_cldr](https://github.com/twitter/twitter-cldr-rb#sorting-collation) offers the same functionality, and much, much more.
* [ICU](https://github.com/jarib/ffi-icu) has collation, encoding detection and more.
* [sort-alphabetical](http://github.com/grosser/sort_alphabetical) does a kind of collation that sorts accented letters same as their non-accented counterparts. It's not proper locale-sensitive collation, but might fit your needs.

Installation
-----

Add this line to your `Gemfile`:

```ruby
gem 'ffi-locale', github: 'k3rni/ffi-locale'
```

You **need to install the GitHub version** of this gem, because it was never pushed to RubyGems due to naming conflicts. RubyGems has [seanohalpin's very similar gem](https://github.com/seanohalpin/ffi-locale) under this name. Check for that before reporting errors.

Usage
-----

##### `strcoll` approach (individual string comparison: transformation and comparison in one step):

    irb> FFILocale.setlocale FFILocale::LC_COLLATE, 'pl_PL.UTF8'
    irb> FFILocale.strcoll "łyk", "myk"
    -1 # Correct collation order. In Polish alphabet, 'ł' comes between 'l' and 'm'.
    irb> "łyk" <=> "myk"
    1 # Incorrect collation. Correct with respect to Ruby semantics, which compares bytewise.
    irb> %w(m l ł).sort { |a, b| FFILocale.strcoll a, b }
    ["l", "ł", "m"]

##### `strxfrm` approach (mass string sorting: bulk-transform first, then rely on Ruby built-in string comparison):

    irb> strings = %w(Ágnes Andor Cecil Cvi Csaba Elemér Éva Géza Gizella György Győző Lóránd Lotár Lőrinc Lukács Orsolya Ödön Ulrika Üllő)
    irb> FFILocale.setlocale FFILocale::LC_COLLATE, 'hu-HU.UTF8'
    irb> sorted = strings.shuffle.sort_by{|s| FFILocale.strxfrm(s)}
    => ["Ágnes", "Andor", "Cecil", "Cvi", "Csaba", "Elemér", "Éva", "Géza", "Gizella", "György", "Győző", "Lóránd", "Lotár", "Lőrinc", "Lukács", "Orsolya", "Ödön", "Ulrika", "Üllő"]
    irb> sorted == strings
    true

One advantage of using `strxfrm` with `sort_by` is performace: the collation transform is computed only once for each item; another is that `sort_by` makes it easier to sort by a compound value (e.g. multiple columns):

    irb> FFILocale.setlocale FFILocale::LC_COLLATE, 'hu-HU.UTF8'
    irb> [{name: "Ágnes", id: 789}, {name: "Andor", id: 456}, {name: "Ágnes", id: 123}].sort_by{|u| [FFILocale.strxfrm(u[:name]), u[:id]] }
    => [{:name=>"Ágnes", :id=>123}, {:name=>"Ágnes", :id=>789}, {:name=>"Andor", :id=>456}]

Not implemented
---------------

* Extensions to String class, to facilitate collation.
* Altering default String sort order. Bad idea - won't be implemented.
* Extensions to Array or Enumerable, to add or alter sort methods. Unnecessary, because passing 
  blocks to `sort` and `sort_by` solves the issue (see example above).
* Not tested beyond Linux. Patches are welcome.
     
Copyright
---------

Copyright © 2011-2015 Krzysztof Zych. See LICENSE.txt for
further details.

