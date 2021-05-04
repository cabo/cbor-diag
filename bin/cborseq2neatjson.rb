#!/usr/bin/env ruby
require 'json'
require 'cbor-pure'
require 'neatjson'
require 'cbor-deterministic'
require 'cbor-canonical'

options = ''
while /\A-([cdpq]+)\z/ === ARGV[0]
  options << $1
  ARGV.shift
end

ARGF.binmode
i = ARGF.read
while i != ''
  o, i = CBOR.decode_with_rest(i)
  o = o.to_packed_cbor if /p/ === options
  o = o.to_unpacked_cbor if /q/ === options
  o = o.cbor_pre_canonicalize if /c/ === options
  o = o.cbor_prepare_deterministic if /d/ === options
  puts JSON.neat_generate(o, after_comma: 1, after_colon: 1)
end
