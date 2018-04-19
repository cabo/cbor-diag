#!/usr/bin/env ruby
require 'json'
require 'cbor-pure'

ARGF.binmode
i = ARGF.read
while i != ''
  o, i = CBOR.decode_with_rest(i)
  puts JSON.pretty_generate(o)
end
