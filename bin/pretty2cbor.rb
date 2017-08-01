#!/usr/bin/env ruby
require 'cbor-pure'
require 'cbor-pretty'


def extractbytes(s)
  s.each_line.map {|ln| ln.sub(/#.*/, '')}.join.scan(/[0-9a-fA-F][0-9a-fA-F]/).map {|b| b.to_i(16).chr(Encoding::BINARY)}.join
end

print(extractbytes(ARGF))
