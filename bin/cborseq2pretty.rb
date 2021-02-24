#!/usr/bin/env ruby
require 'cbor-pure'
require 'cbor-pretty'

ARGF.binmode
i = ARGF.read
puts CBOR::pretty_seq(i)
