#!/usr/bin/env ruby
require 'cbor-diagnostic'

ARGF.binmode
i = ARGF.read
o,r = CBOR.decode_with_rest(i)
if r != ''
  warn "** ignoring rest of #{r.bytesize} bytes after first CBOR data item"
end
puts o.cbor_diagnostic
