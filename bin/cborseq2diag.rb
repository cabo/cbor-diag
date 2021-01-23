#!/usr/bin/env ruby
require 'cbor-diagnostic'


if ARGV[0] == "-e"
  embcbor = true
  ARGV.shift
end

ARGF.binmode
i = ARGF.read
oo = CBOR.decode_seq(i)
oo.each { |o|
  puts o.cbor_diagnostic(try_decode_embedded: !!embcbor)
}
