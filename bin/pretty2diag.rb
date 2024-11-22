#!/usr/bin/env ruby
require 'cbor-pretty'
require 'cbor-diagnostic'


require 'cbor-diagnostic-helper'
options = cbor_diagnostic_process_args("cdetpqun")


i = CBOR.extract_bytes_from_hex(ARGF)
o = CBOR.decode(i)
puts cbor_diagnostic_output(o, options)
