require 'cbor-packed'
require 'cbor-deterministic'
require 'cbor-canonical'

def cbor_diagnostic_process_args(chars)
  options = ''
  while /\A-(?:([#{chars}]+)|([#{chars}]*)([aw])(.*))\z/ === ARGV[0]
    ARGV.shift
    options << $1 if $1
    options << $2 if $2
    if (o = $3) && (s = $4)
      s = ARGV.shift if s == ""
      case o
      when "a"
        s.split(",").each do |a|
          require "cbor-diagnostic-app/#{a}"
        end
      when "w"
        options << "w#{s.to_i}"
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
                    utf8: /u/ === options,
                    nan: /n/ === options,
                    no_nan: /N/ === options,
                    terminator: /T/ === options,
                    wrap: if /w([0-9]+)/ === options; $1.to_i; end)
end
