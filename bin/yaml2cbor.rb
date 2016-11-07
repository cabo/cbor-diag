#!/usr/bin/env ruby
require 'psych.rb'              # WTF
require 'yaml'
require 'cbor-pure'

if ARGV[0] == "-v"
  verbose = true
  ARGV.shift
end

$stdout.binmode
i = ARGF.read
o = CBOR.encode(YAML.load(i))
print o
warn "YAML size: #{i.size} bytes, CBOR size: #{o.size} bytes." if verbose
