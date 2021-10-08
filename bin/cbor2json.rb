#!/usr/bin/env ruby
require 'json'
require 'cbor-pure'
require 'cbor-packed'
require 'cbor-deterministic'
require 'cbor-canonical'

options = ''
while /\A-([cdpqj]+)\z/ === ARGV[0]
  options << $1
  ARGV.shift
end

ARGF.binmode
i = ARGF.read
o = CBOR.decode(i)
o = o.to_packed_cbor if /p/ === options
o = o.to_unpacked_cbor if /q/ === options
o = o.cbor_pre_canonicalize if /c/ === options
o = o.cbor_prepare_deterministic if /d/ === options
if /j/ === options
  require 'cbor-transform-j'
  o = CBOR::Transform_j.new.transform(o)
end
puts JSON.pretty_generate(o)
