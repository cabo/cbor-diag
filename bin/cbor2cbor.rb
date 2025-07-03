#!/usr/bin/env ruby
require 'cbor-diagnostic'
require 'cbor-packed'
require 'cbor-deterministic'
require 'cbor-canonical'


require 'cbor-diagnostic-helper'
options = cbor_diagnostic_process_args("cdpq")

$stdout.binmode
ARGF.binmode
i = ARGF.read
o = CBOR.decode(i)
print(CBOR::encode(cbor_diagnostic_item_processing(o, options)))

