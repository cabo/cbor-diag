#!/usr/bin/env ruby
require 'cbor-diagnostic'


if ARGV[0] == "-e"
  embcbor = true
  ARGV.shift
end

ARGF.binmode
i = ARGF.read
o = CBOR.decode(i)
puts o.cbor_diagnostic(try_decode_embedded: !!embcbor)
