#!/usr/bin/env ruby
require 'cbor-diagnostic'

options = ''
while /\A-([et]+)\z/ === ARGV[0]
  options << $1
  ARGV.shift
end

ARGF.binmode
i = ARGF.read
o = CBOR.decode(i)
puts o.cbor_diagnostic(try_decode_embedded: /e/ === options, bytes_as_text: /t/ === options)
