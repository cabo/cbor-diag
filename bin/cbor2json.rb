#!/usr/bin/env ruby
require 'json'
require 'cbor-pure'

ARGF.binmode
i = ARGF.read
o = CBOR.decode(i)
puts JSON.pretty_generate(o)
