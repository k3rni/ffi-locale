ffi-locale
==========

A small gem to aid with locale-sensitive string comparison (collation), which ruby lacks by default. Roughly based on
Matz' [rather ancient code](http://www.justskins.com/forums/ruby-talk-newbie-locale-8419.html). 
However, instead of creating a wrapper around these functions, I call them using FFI.

Scope
-----

Everything this library does could be accomplished by adding two functions to [ffi-libc](https://github.com/postmodern/ffi-libc).
However, I didn't need any of the extra bindings ffi-libc would bring, and decided to separate the functionality.

The library offers only 3 functions, all of them thin wrappers over libc functionality:

* [strcoll](http://www.gnu.org/software/libc/manual/html_node/Collation-Functions.html)
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

Usage
-----

Install the gem, or add to your Gemfile.

    irb> FFILocale::setlocale FFILocale::LC_COLLATE, 'pl_PL.UTF8'
    irb> FFILocale::strcoll "łyk", "myk"
    -1 # Correct collation order. In Polish alphabet, 'ł' comes between 'l' and 'm'.
    irb> "łyk" <=> "myk"
    1 # Incorrect collation. Correct with respect to Ruby semantics, which compares bytewise.
    irb> %w(m l ł).sort { |a, b| FFILocale::strcoll a, b }
    ["l", "ł", "m"]

Not implemented
---------------

* Extensions to String class, to facilitate collation.
* Altering default String sort order. Bad idea - won't be implemented.
* Extensions to Array or Enumerable, to add or alter sort methods. Unnecessary, because passing 
  blocks to `sort` and `sort_by` solves the issue (see above).
     
Copyright
---------

Copyright © 2011-2013 Krzysztof Zych. See LICENSE.txt for
further details.

