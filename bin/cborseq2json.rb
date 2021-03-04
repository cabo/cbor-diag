#!/usr/bin/env ruby
require 'json'
require 'cbor-pure'
require 'cbor-deterministic'
require 'cbor-canonical'

options = ''
while /\A-([cd]+)\z/ === ARGV[0]
  options << $1
  ARGV.shift
end

ARGF.binmode
i = ARGF.read
while i != ''
  o, i = CBOR.decode_with_rest(i)
  o = o.cbor_pre_canonicalize if /c/ === options
  o = o.cbor_prepare_deterministic if /d/ === options
  puts JSON.pretty_generate(o)
end
