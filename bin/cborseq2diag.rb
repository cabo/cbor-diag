#!/usr/bin/env ruby
require 'cbor-diagnostic'
require 'cbor-packed'
require 'cbor-deterministic'
require 'cbor-canonical'

require 'cbor-diagnostic-helper'
options = cbor_diagnostic_process_args("cdetpqu")

ARGF.binmode
i = ARGF.read
totalsize = i.bytesize
while !i.empty?
  begin
    o, i = CBOR.decode_with_rest(i)
  rescue Exception => e
    puts "/ *** Garbage at byte #{totalsize-i.bytesize}: #{e.message} /"
    exit 1
  end
  out = cbor_diagnostic_output(o, options)
  if i.empty?
    puts out
  else
    print out << ', '
  end
end
