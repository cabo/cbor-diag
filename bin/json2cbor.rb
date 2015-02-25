#!/usr/bin/env ruby
require 'json'
require 'cbor-pure'

if ARGV[0] == "-v"
  verbose = true
  ARGV.shift
end

$stdout.binmode
i = ARGF.read
o = CBOR.encode(JSON.load(i))
print o
warn "JSON size: #{i.size} bytes, CBOR size: #{o.size} bytes." if verbose
