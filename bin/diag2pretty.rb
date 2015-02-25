#!/usr/bin/env ruby
require 'cbor-pure'
require 'treetop'
require 'cbor-diag-parser'
require 'cbor-pretty'

parser = CBOR_DIAGParser.new

i = ARGF.read
if result = parser.parse(i)
  puts(CBOR::pretty(CBOR::encode(result.to_rb)))
else
  puts "*** can't parse #{i}"
  puts "*** #{parser.failure_reason}"
end
