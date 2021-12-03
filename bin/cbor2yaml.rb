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

require 'cbor-diagnostic-helper'
options = cbor_diagnostic_process_args("cdpq")

ARGF.binmode
i = ARGF.read
o = CBOR.decode(i)
o = cbor_diagnostic_item_processing(o, options)
puts YAML.dump(o)
