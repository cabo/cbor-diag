#!/usr/bin/env ruby
require 'json'
require 'cbor-pure'
require 'cbor-pretty'

i = ARGF.read
o = CBOR.pretty(CBOR.encode(JSON.load(i)))
print o
