#!/usr/bin/env ruby
require 'cbor-diagnostic'

ARGF.binmode
i = ARGF.read
o = CBOR.decode(i)
puts o.cbor_diagnostic
