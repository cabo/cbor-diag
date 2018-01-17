#!/usr/bin/env ruby
require 'cbor-pure'
require 'treetop'
require 'cbor-diag-parser'
unless ''.respond_to? :b
  require 'cbor-diagnostic'     # for .b
end
require 'cbor-pretty'

parser = CBOR_DIAGParser.new

$stdout.binmode

i = ARGF.read.b                 # binary to work around treetop performance bug
if result = parser.parse(i)
  print(CBOR::encode(result.to_rb))
else
  puts "*** can't parse #{i}"
  puts "*** #{parser.failure_reason}"
end
