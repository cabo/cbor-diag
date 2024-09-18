#!/usr/bin/env ruby
require 'cbor-pure'
require 'treetop'
require 'cbor-diag-parser'
require 'cbor-pretty'

require 'cbor-diagnostic-helper'
options = cbor_diagnostic_process_args("X") # XXX

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
  warn "*** can't parse #{i}"
  warn "*** #{parser.failure_reason}"
  exit 1
end
