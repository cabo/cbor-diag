#!/usr/bin/env ruby
require 'cbor-pure'
require 'treetop'
require 'cbor-diag-parser'
require 'cbor-pretty'

parser = CBOR_DIAGParser.new

i = ARGF.read
if result = parser.parse(i)
  decoded = result.to_rb
  puts case decoded
        when CBOR::Sequence
          "# CBOR sequence with #{decoded.elements.size} elements\n" <<
            CBOR::pretty_seq(CBOR::encode_seq(decoded.elements))
        else
          CBOR::pretty(CBOR::encode(decoded))
        end
else
  puts "*** can't parse #{i}"
  puts "*** #{parser.failure_reason}"
end
