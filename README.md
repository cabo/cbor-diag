# CBOR diagnostic utilities

This little set of tools provides a number of command line utilities
for converting to and from [CBOR](http://cbor.io) and its diagnostic
notation as well as some libraries for this in the Ruby language.

[![0.1.2](https://badge.fury.io/rb/cbor-diag.svg)](http://badge.fury.io/rb/cbor-diag)

## Installation

`gem install cbor-diag`

## Command line utilities

Specifically, the tools...

* cbor2diag.rb
* cbor2json.rb
* cbor2pretty.rb
* cbor2yaml.rb
* diag2cbor.rb
* diag2pretty.rb
* json2cbor.rb
* json2pretty.rb
* pretty2cbor.rb
* yaml2cbor.rb

...do pretty much what you would expect them to do, given these definitions:

* "cbor" is binary CBOR.
* "diag" is CBOR's [diagnostic notation](http://tools.ietf.org/html/rfc7049#section-6).
* "json" is [JSON](http://json.org).
* "pretty" is the pretty-printed representation of binary CBOR as used by
  [cbor.me](http://cbor.me).).
* "yaml" is [YAML](http://yaml.org).

Output is to stdout, input from stdin or files given as command line
arguments). (`json2cbor.rb` also has a `-v` option.)

These commands have a .rb suffix to avoid conflicts: versions of the
same functionality are available under similar names in other CBOR
packages, e.g. `json2cbor` in the
[CBOR NPM](https://github.com/hildjj/node-cbor).

## Ruby libraries

* "cbor-pure" is a pure-Ruby implementation of CBOR, with some
  diagnostic capabilities.  It is aided by "half.rb" for 16-bit
  IEEE 754 floating point numbers (which Ruby strangely doesn't
  directly support).
* "cbor-diag-parser" is a parser for CBOR's diagnostic notation and
  the heart of diag2cbor.rb and diag2pretty.rb.  (Source is in
  [treetop](https://github.com/nathansobo/treetop); compiled .rb also included.)
* "cbor-diagnostic" is a dumper for CBOR's diagnostic notation.
* "cbor-pretty" is a pretty-printer for binary CBOR.

No documentation; use the source, for now (the above command line
utilities should show the basic usage).

