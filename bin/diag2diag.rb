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
options = cbor_diagnostic_process_args("cdetpqunNT")

parser = CBOR_DIAGParser.new

i = ARGF.read.b                 # binary to work around treetop performance bug
if result = parser.parse(i)
  decoded = result.to_rb
  out = cbor_diagnostic_output(decoded, options)
  puts out
else
  warn "*** can't parse #{i}"
  warn "*** #{parser.failure_reason}"
  exit 1
end
