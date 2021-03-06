#!/usr/bin/env ruby
require 'psych.rb'              # WTF
require 'yaml'
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
o = YAML.load(i)
o = o.to_packed_cbor if /p/ === options
o = o.to_unpacked_cbor if /q/ === options
o = o.cbor_pre_canonicalize if /c/ === options
o = o.cbor_prepare_deterministic if /d/ === options
o = CBOR.encode(o)
print o
warn "YAML size: #{i.size} bytes, CBOR size: #{o.size} bytes." if /v/ === options
