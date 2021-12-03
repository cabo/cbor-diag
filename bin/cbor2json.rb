#!/usr/bin/env ruby
require 'json'
require 'cbor-pure'
require 'cbor-packed'
require 'cbor-deterministic'
require 'cbor-canonical'


require 'cbor-diagnostic-helper'
options = cbor_diagnostic_process_args("cdpqj")

ARGF.binmode
i = ARGF.read
o = CBOR.decode(i)
o = cbor_diagnostic_item_processing(o, options)
if /j/ === options
  require 'cbor-transform-j'
  o = CBOR::Transform_j.new.transform(o)
end
puts JSON.pretty_generate(o)
