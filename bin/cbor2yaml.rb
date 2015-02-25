#!/usr/bin/env ruby
require 'psych.rb'              # WTF
require 'yaml'
require 'cbor-pure'

class Array
  def to_yaml_style()
    all? {|x| Integer === x } && length < 20 ? :inline : super
  end
end

ARGF.binmode
i = ARGF.read
o = CBOR.decode(i)
puts YAML.dump(o)
