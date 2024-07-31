#!/usr/bin/env ruby
require 'cbor-diagnostic'
require 'cbor-packed'
require 'cbor-deterministic'
require 'cbor-canonical'


require 'cbor-diagnostic-helper'
options = cbor_diagnostic_process_args("cdetpqun")

ARGF.binmode
i = ARGF.read
o = CBOR.decode(i)
puts cbor_diagnostic_output(o, options)
