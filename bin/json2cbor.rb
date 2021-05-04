#!/usr/bin/env ruby
require 'json'
require 'cbor-pure'
require 'cbor-packed'
require 'cbor-deterministic'
require 'cbor-canonical'

options = ''
while /\A-([cdpqv]+)\z/ === ARGV[0]
  options << $1
  ARGV.shift
end

$stdout.binmode
i = ARGF.read
o = JSON.load(i)
o = o.to_packed_cbor if /p/ === options
o = o.to_unpacked_cbor if /q/ === options
o = o.cbor_pre_canonicalize if /c/ === options
o = o.cbor_prepare_deterministic if /d/ === options
o = CBOR.encode(o)
print o
warn "JSON size: #{i.size} bytes, CBOR size: #{o.size} bytes." if /v/ === options
