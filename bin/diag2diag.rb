#!/usr/bin/env ruby
require 'cbor-pure'
require 'treetop'
require 'cbor-diag-parser'
unless ''.respond_to? :b
  require 'cbor-diagnostic'     # for .b
end
require 'cbor-pretty'
require 'cbor-diagnostic'

require 'cbor-diagnostic-helper'
options = cbor_diagnostic_process_args("cdetpqun")

parser = CBOR_DIAGParser.new

i = ARGF.read.b                 # binary to work around treetop performance bug
if result = parser.parse(i)
  decoded = result.to_rb
  out = case decoded
        when CBOR::Sequence
          decoded.elements
        else
          [decoded]
        end.map {|x| cbor_diagnostic_output(x, options)}.join(", ")
  puts out
else
  puts "*** can't parse #{i}"
  puts "*** #{parser.failure_reason}"
end
