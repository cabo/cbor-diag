#!/usr/bin/env ruby
require 'cbor-pure'
require 'cbor-pretty'

ARGF.binmode
i = ARGF.read
i.bytes.each_slice(8) do |s|
  puts s.map {|b| "0x%02x," % b}.join(" ")
end
