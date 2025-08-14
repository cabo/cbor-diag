# -*- coding: utf-8 -*-

# This should work with the C-ext cbor-ruby as well as with our cbor-pure
unless defined?(CBOR)
  require 'cbor-pure'
end
require 'json'

UPPERCASE_HEX = ENV["UPPERCASE_HEX"]
HEX_FORMAT = UPPERCASE_HEX ? "%02X" : "%02x"

class String
  def hexbytes(sep = '')
    bytes.map{|x| HEX_FORMAT % x}.join(sep)
  end
  def to_json_514_workaround
    ret = to_json
    ret.encode(Encoding::UTF_16BE) # exception if bad
    ret
  end
end


module CBOR

  def self.extract_bytes_from_hex(s)
    s.each_line.map {|ln| ln.sub(/#.*/, '')}.join.scan(/[0-9a-fA-F][0-9a-fA-F]/).map {|b| b.to_i(16).chr(Encoding::BINARY)}.join
  end

  def self.pretty(s, indent = 0, max_target = 40)
    Buffer.new(s).pretty_item_final(indent, max_target)
  end

  def self.pretty_seq(s, indent = 0, max_target = 40)
    b = Buffer.new(s)
    res = ''                    # XXX: not all indented the same
    while !b.empty?
      res << b.pretty_item_final(indent, max_target, true)
    end
    res
  end

  class Buffer

  def take_and_print(n, prefix = '')
    s = take(n)
    @out << prefix
    @out << s.hexbytes
    s
  end

  def pretty_item_streaming(ib)
    res = nil
    @out << " # #{MT_NAMES[ib >> 5]}(*)\n"
    @indent += 1
    case ib >>= 5
    when 2, 3, 4, 5
      while (element = pretty_item) != BREAK
      end
    when 7; res = BREAK
    else raise "unknown ib #{ib} for additional information 31"
    end
    @indent -= 1
    res
  end

  MT_NAMES = ["unsigned", "negative", "bytes", "text", "array", "map", "tag", "primitive"]

  def pretty_item
    ib = take_and_print(1, '   ' * @indent).ord
    ai = ib & 0x1F
    val = case ai
          when 0...24; ai
          when 24; take_and_print(1, ' ').ord
          when 25; take_and_print(2, ' ').unpack("n").first
          when 26; (s = take_and_print(4, ' ')).unpack("N").first
          when 27; (s = take_and_print(8, ' ')).unpack("Q>").first
          when 31; return pretty_item_streaming(ib)
          else raise "unknown additional information #{ai} in ib #{ib}"
          end
    @out << " # #{MT_NAMES[ib >> 5]}(#{val})\n"
    @indent += 1
    case ib >>= 5
    when 6
      pretty_item
    when 2, 3
      @out << '   ' * (@indent)
      s = take_and_print(val)
      @out << " # #{s.force_encoding(Encoding::UTF_8).to_json_514_workaround rescue s.inspect}"
      @out << "\n"
    when 4; val.times { pretty_item }
    when 5; val.times { pretty_item; pretty_item}
    end
    @indent -= 1
    nil
  end

  def pretty_item_final(indent = 0, max_target = 40, seq = false)
    @out = ''
    @indent = indent
    pretty_item
    unless seq
      raise if @pos != @buffer.size
    end
    target = [@out.each_line.map {|ln| ln.index('#') || 0}.max, max_target].min
    @out.each_line.map {|ln|
      col = ln.index('#')
      if col && col < target
        ln[col, 0] = ' ' * (target - col)
      end
      ln
    }.join
  end

  end

end
