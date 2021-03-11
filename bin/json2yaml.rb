#!/usr/bin/env ruby
require 'psych.rb'              # WTF
require 'yaml'
require 'json'
require 'cbor-pure'
require 'cbor-deterministic'
require 'cbor-canonical'

class Array
  def to_yaml_style()
    all? {|x| Integer === x } && length < 20 ? :inline : super
  end
end

options = ''
while /\A-([cd]+)\z/ === ARGV[0]
  options << $1
  ARGV.shift
end

i = ARGF.read
o = JSON.load(i)
o = o.cbor_pre_canonicalize if /c/ === options
o = o.cbor_prepare_deterministic if /d/ === options
puts YAML.dump(o)
