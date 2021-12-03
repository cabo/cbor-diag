require 'cbor-packed'
require 'cbor-deterministic'
require 'cbor-canonical'

def cbor_diagnostic_process_args(chars)
  options = ''
  while /\A-(?:([#{chars}]+)|a(.*))\z/ === ARGV[0]
    ARGV.shift
    if $1
      options << $1
    else
      s = $2
      s = ARGV.shift if s == ""
      s.split(",").each do |a|
        require "cbor-diagnostic-app/#{a}"
      end
    end
  end
  options
end

def cbor_diagnostic_item_processing(o, options)
  o = o.to_packed_cbor if /p/ === options
  o = o.to_unpacked_cbor if /q/ === options
  o = o.cbor_pre_canonicalize if /c/ === options
  o = o.cbor_prepare_deterministic if /d/ === options
  o
end

def cbor_diagnostic_output(o, options)
  o = cbor_diagnostic_item_processing(o, options)
  o.cbor_diagnostic(try_decode_embedded: /e/ === options,
                    bytes_as_text: /t/ === options,
                    utf8: /u/ === options)
end
