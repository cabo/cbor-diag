#!/usr/bin/env ruby
require 'json'
require 'cbor-pure'
require 'cbor-packed'
require 'cbor-deterministic'
require 'cbor-canonical'


require 'cbor-diagnostic-helper'
options = cbor_diagnostic_process_args("cdpqvj")

$stdout.binmode
i = ARGF.read
o = JSON.load(i)
if /j/ === options
  require 'cbor-transform-j'
  o = CBOR::Transform_jr.new.transform(o)
end
o = cbor_diagnostic_item_processing(o, options)
o = CBOR.encode(o)
print o
warn "JSON size: #{i.size} bytes, CBOR size: #{o.size} bytes." if /v/ === options
