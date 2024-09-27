# CBOR diagnostic utilities

This little set of tools provides a number of command line utilities
for converting to and from [CBOR](https://cbor.io) and its diagnostic
notation as well as some libraries for this in the Ruby language.

[![0.1.2](https://badge.fury.io/rb/cbor-diag.svg)](https://badge.fury.io/rb/cbor-diag)

## Installation

`gem install cbor-diag`

## Command line utilities

Specifically, the tools...

* cbor2diag.rb
* cbor2json.rb
* cbor2pretty.rb
* cbor2yaml.rb
* cbor2u8.rb
* cborseq2diag.rb
* cborseq2json.rb
* cborseq2neatjson.rb
* cborseq2yaml.rb
* diag2cbor.rb
* diag2pretty.rb
* json2cbor.rb
* json2pretty.rb
* pretty2cbor.rb
* pretty2diag.rb
* yaml2cbor.rb

...do pretty much what you would expect them to do, given these definitions:

* "cbor" is a single binary CBOR data item.
* "cborseq" is a sequence of zero or more binary CBOR data items.
* "diag" is CBOR's [diagnostic notation][DN],
  with the extensions in [RFC 8610][EDN] (extended
  diagnostic notation, EDN) and [RFC 8742][SeqDN] (without the outer brackets).
* "json" is [JSON](https://json.org).
* "neatjson" is a neater form of JSON.
* "pretty" is the pretty-printed representation of binary CBOR as used by
  [cbor.me](http://cbor.me).
* "yaml" is [YAML](https://yaml.org).

[DN]: https://www.rfc-editor.org/rfc/rfc8949#name-diagnostic-notation
[EDN]: https://www.rfc-editor.org/rfc/rfc8610#appendix-G
[SeqDN]: https://www.rfc-editor.org/rfc/rfc8742#name-diagnostic-notation

Output is to stdout, input from stdin or files given as command line
arguments.  Options:

* `json2cbor.rb`:
    * `-v`: be verbose about sizes in bytes.
* `cbor2diag.rb`, `cborseq2diag.rb`:
    * `-e`: output byte strings as embedded CBOR if well-formed as such (e.g.,
      `printf 'CBOR' | cbor2diag.rb -et` outputs `<< 'OR' >>`).
    * `-t`: output byte strings that are valid UTF-8 text as such in single
      quotes (e.g., `'foo'` instead of `h'666F6F'`).
    * `-u`: don't escape beyond-ASCII characters in strings (e.g., `"ü"`
      instead of `"\u00fc"`)

These commands have a .rb suffix in their names to avoid conflicts: versions of the
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

