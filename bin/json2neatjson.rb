#!/usr/bin/env ruby
require 'json'
require 'cbor-pure'
require 'neatjson'
require 'cbor-deterministic'
require 'cbor-canonical'

options = ''
while /\A-([cd]+)\z/ === ARGV[0]
  options << $1
  ARGV.shift
end

$stdout.binmode
i = ARGF.read
o = JSON.load(i)
o = o.cbor_pre_canonicalize if /c/ === options
o = o.cbor_prepare_deterministic if /d/ === options
puts JSON.neat_generate(o, after_comma: 1, after_colon: 1)
