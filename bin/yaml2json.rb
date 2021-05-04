#!/usr/bin/env ruby
require 'json'
require 'psych.rb'              # WTF
require 'yaml'
require 'cbor-pure'
require 'cbor-packed'
require 'cbor-deterministic'
require 'cbor-canonical'

options = ''
while /\A-([cdpq]+)\z/ === ARGV[0]
  options << $1
  ARGV.shift
end

i = ARGF.read
o = YAML.load(i)
o = o.to_packed_cbor if /p/ === options
o = o.to_unpacked_cbor if /q/ === options
o = o.cbor_pre_canonicalize if /c/ === options
o = o.cbor_prepare_deterministic if /d/ === options
puts JSON.pretty_generate(o)
