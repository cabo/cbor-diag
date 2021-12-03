#!/usr/bin/env ruby
require 'json'
require 'cbor-pure'
require 'cbor-packed'
require 'cbor-deterministic'
require 'cbor-canonical'

require 'cbor-diagnostic-helper'
options = cbor_diagnostic_process_args("cdpq")

i = ARGF.read
o = JSON.load(i)
o = cbor_diagnostic_item_processing(o, options)
puts JSON.pretty_generate(o)
