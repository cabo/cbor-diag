#!/usr/bin/env ruby
require 'cbor-diagnostic'
require 'cbor-packed'
require 'cbor-deterministic'
require 'cbor-canonical'

require 'cbor-diagnostic-helper'
options = cbor_diagnostic_process_args("cdetpqu")

ARGF.binmode
i = ARGF.read
o,r = CBOR.decode_with_rest(i)
if r != ''
  warn "** ignoring rest of #{r.bytesize} bytes after first CBOR data item"
end
puts cbor_diagnostic_output(o, options)
