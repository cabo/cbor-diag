#!/usr/bin/env ruby
require 'cbor-pretty'
require 'cbor-diagnostic'


def extractbytes(s)
  s.each_line.map {|ln| ln.sub(/#.*/, '')}.join.scan(/[0-9a-fA-F][0-9a-fA-F]/).map {|b| b.to_i(16).chr(Encoding::BINARY)}.join
end

i = extractbytes(ARGF)
o = CBOR.decode(i)
puts o.cbor_diagnostic
