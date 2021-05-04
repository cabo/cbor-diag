#!/usr/bin/env ruby
require 'cbor-pure'
require 'treetop'
require 'cbor-diag-parser'
unless ''.respond_to? :b
  require 'cbor-diagnostic'     # for .b
end
require 'cbor-pretty'
require 'cbor-diagnostic'
require 'cbor-packed'
require 'cbor-deterministic'
require 'cbor-canonical'

options = ''
while /\A-([cdetpqu]+)\z/ === ARGV[0]
  options << $1
  ARGV.shift
end

def diagnostic(o, options)
  o = o.to_packed_cbor if /p/ === options
  o = o.to_unpacked_cbor if /q/ === options
  o = o.cbor_pre_canonicalize if /c/ === options
  o = o.cbor_prepare_deterministic if /d/ === options
  puts o.cbor_diagnostic(try_decode_embedded: /e/ === options,
                         bytes_as_text: /t/ === options,
                         utf8: /u/ === options)
end

parser = CBOR_DIAGParser.new

i = ARGF.read.b                 # binary to work around treetop performance bug
if result = parser.parse(i)
  decoded = result.to_rb
  out = case decoded
        when CBOR::Sequence
          decoded.elements
        else
          [decoded]
        end.map {|x| diagnostic(x, options)}.join(", ")
  print out
else
  puts "*** can't parse #{i}"
  puts "*** #{parser.failure_reason}"
end
