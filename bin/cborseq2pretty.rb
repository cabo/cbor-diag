#!/usr/bin/env ruby
require 'cbor-pure'
require 'cbor-pretty'

ARGF.binmode
i = ARGF.read
while !i.empty?
  o, ni = CBOR.decode_with_rest(i)
  puts CBOR::pretty(i[0...i.size-ni.size])
  i = ni
end
