#!/usr/bin/env ruby
require 'cbor-pure'
require 'cbor-pretty'

print(CBOR.extract_bytes_from_hex(ARGF))
