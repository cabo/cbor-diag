#!/usr/bin/env ruby
require 'cbor-diagnostic'
require 'cbor-packed'
require 'cbor-deterministic'
require 'cbor-canonical'

options = ''
while /\A-([cdetpqu]+)\z/ === ARGV[0]
  options << $1
  ARGV.shift
end

ARGF.binmode
i = ARGF.read
o,r = CBOR.decode_with_rest(i)
if r != ''
  warn "** ignoring rest of #{r.bytesize} bytes after first CBOR data item"
end
o = o.to_packed_cbor if /p/ === options
o = o.to_unpacked_cbor if /q/ === options
o = o.cbor_prepare_deterministic if /d/ === options
o = o.cbor_pre_canonicalize if /c/ === options
puts o.cbor_diagnostic(try_decode_embedded: /e/ === options,
                       bytes_as_text: /t/ === options,
                       utf8: /u/ === options)
