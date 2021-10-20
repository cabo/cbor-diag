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
totalsize = i.bytesize
while !i.empty?
  begin
    o, i = CBOR.decode_with_rest(i)
  rescue Exception => e
    puts "/ *** Garbage at byte #{totalsize-i.bytesize}: #{e.message} /"
    break
  end
  o = o.to_packed_cbor if /p/ === options
  o = o.to_unpacked_cbor if /q/ === options
  o = o.cbor_pre_canonicalize if /c/ === options
  o = o.cbor_prepare_deterministic if /d/ === options
  out = o.cbor_diagnostic(try_decode_embedded: /e/ === options,
                          bytes_as_text: /t/ === options,
                          utf8: /u/ === options)
  if i.empty?
    puts out
  else
    print out << ', '
  end
end
