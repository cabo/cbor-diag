#!/usr/bin/env ruby
require 'json'
require 'cbor-pure'
require 'cbor-deterministic'
require 'cbor-canonical'

require 'cbor-diagnostic-helper'
options = cbor_diagnostic_process_args("cdpq")

ARGF.binmode
i = ARGF.read
while i != ''
  o, i = CBOR.decode_with_rest(i)
  o = cbor_diagnostic_item_processing(o, options)
  puts JSON.pretty_generate(o)
end
