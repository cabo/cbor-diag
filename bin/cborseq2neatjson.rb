#!/usr/bin/env ruby
require 'json'
require 'cbor-pure'
require 'neatjson'

ARGF.binmode
i = ARGF.read
while i != ''
  o, i = CBOR.decode_with_rest(i)
  puts JSON.neat_generate(o, after_comma: 1, after_colon: 1)
end
