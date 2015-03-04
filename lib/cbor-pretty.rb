# -*- coding: utf-8 -*-

# This should work with the C-ext cbor-ruby as well as with our cbor-pure
unless defined?(CBOR)
  require 'cbor-pure'
end

class String
  def hexbytes(sep = '')
    bytes.map{|x| "%02x" % x}.join(sep)
  end
end


class CBOR
  def self.pretty(s, indent = 0, max_target = 40)
    new(s).pretty_item_final(indent, max_target)
  end

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
      @out << " # #{s.inspect}"
      @out << "\n"
    when 4; val.times { pretty_item }
    when 5; val.times { pretty_item; pretty_item}
    end
    @indent -= 1
    nil
  end

  def pretty_item_final(indent = 0, max_target = 40)
    @out = ''
    @indent = indent
    pretty_item
    raise if @pos != @buffer.size
    target = [@out.each_line.map {|ln| ln =~ /#/ || 0}.max, max_target].min
    @out.each_line.map {|ln|
      col = ln =~ /#/
      if col && col < target
        ln[col, 0] = ' ' * (target - col)
      end
      ln
    }.join
  end

end
