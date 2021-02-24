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
  decoded = result.to_rb
  out = case decoded
        when CBOR::Sequence
          CBOR::encode_seq(decoded.elements)
        else
          CBOR::encode(decoded)
        end
  print out
else
  puts "*** can't parse #{i}"
  puts "*** #{parser.failure_reason}"
end
