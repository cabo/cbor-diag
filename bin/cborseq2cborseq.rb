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
totalsize = i.bytesize
while !i.empty?
  begin
    o, i = CBOR.decode_with_rest(i)
  rescue StandardError => e
    puts "/ *** Garbage at byte #{totalsize-i.bytesize}: #{e.message} /"
    exit 1
  end
  print(CBOR::encode(cbor_diagnostic_item_processing(o, options)))
end
