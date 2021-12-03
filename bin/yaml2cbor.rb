#!/usr/bin/env ruby
require 'psych.rb'              # WTF
require 'yaml'
require 'cbor-pure'
require 'cbor-packed'
require 'cbor-deterministic'
require 'cbor-canonical'

require 'cbor-diagnostic-helper'
options = cbor_diagnostic_process_args("cdpqv")

$stdout.binmode
i = ARGF.read
o = YAML.load(i)
o = cbor_diagnostic_item_processing(o, options)
o = CBOR.encode(o)
print o
warn "YAML size: #{i.size} bytes, CBOR size: #{o.size} bytes." if /v/ === options
