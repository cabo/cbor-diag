#!/usr/bin/env ruby
require 'json'
require 'cbor-pure'
require 'neatjson'
require 'cbor-deterministic'
require 'cbor-canonical'


require 'cbor-diagnostic-helper'
options = cbor_diagnostic_process_args("cdpq")

ARGF.binmode
i = ARGF.read
while i != ''
  o, i = CBOR.decode_with_rest(i)
  o = cbor_diagnostic_item_processing(o, options)
  puts JSON.neat_generate(o, after_comma: 1, after_colon: 1)
end
