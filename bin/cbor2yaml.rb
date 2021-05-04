#!/usr/bin/env ruby
require 'psych.rb'              # WTF
require 'yaml'
require 'cbor-pure'
require 'cbor-packed'
require 'cbor-deterministic'
require 'cbor-canonical'

class Array
  def to_yaml_style()
    all? {|x| Integer === x } && length < 20 ? :inline : super
  end
end

options = ''
while /\A-([cdpq]+)\z/ === ARGV[0]
  options << $1
  ARGV.shift
end

ARGF.binmode
i = ARGF.read
o = CBOR.decode(i)
o = o.to_packed_cbor if /p/ === options
o = o.to_unpacked_cbor if /q/ === options
o = o.cbor_prepare_deterministic if /d/ === options
o = o.cbor_pre_canonicalize if /c/ === options
puts YAML.dump(o)
