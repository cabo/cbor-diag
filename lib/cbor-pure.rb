# -*- coding: utf-8 -*-

require "half.rb"


class CBOR
  module Streaming
    def cbor_stream?
      @cbor_streaming
    end
    def cbor_stream!(b = true)
      @cbor_streaming = b
      self
    end
  end
  Array.send(:include, Streaming)
  Hash.send(:include, Streaming)
  String.send(:include, Streaming)

  class Break
  end
  BREAK = Break.new.freeze

  Tagged = Struct.new(:tag, :data) do
    def to_s
      "#{tag}(#{data})"
    end
    def inspect
      "#{tag}(#{data.inspect})"
    end
  end

  TAG_BIGNUM_BASE = 2

  Simple = Struct.new(:value) do
    def to_s
      if value == 23
        "undefined"
      else
        "simple(#{value})"
      end
    end
    alias_method :inspect, :to_s
  end

  def self.encode(d)
    new.add(d).buffer
  end
  def self.decode(s)
    new(s).decode_item_final
  end

  attr_reader :buffer
  def initialize(s = String.new)
    @buffer = s
    @pos = 0
  end

  def head(ib, n)
    @buffer <<
      case n
      when 0...24
        [ib + n].pack("C")
      when 0...256
        [ib + 24, n].pack("CC")
      when 0...65536
        [ib + 25, n].pack("Cn")
      when 0...4294967296
        [ib + 26, n].pack("CN")
      when 0...18446744073709551616
        [ib + 27, n].pack("CQ>")
      else
        yield                   # throw back to caller
      end
  end

  HALF_NAN_BYTES = ("\xf9".force_encoding(Encoding::BINARY) + Half::NAN_BYTES).freeze

  def addfloat(fv)
    if fv.nan?
      @buffer << HALF_NAN_BYTES
    else
      ss = [fv].pack("g")         # single-precision
      if ss.unpack("g").first == fv
        if hs = Half.encode_from_single(fv, ss)
          @buffer << 0xf9 << hs
        else
          @buffer << 0xfa << ss
        end
      else
        @buffer << [0xfb, fv].pack("CG") # double-precision
      end
    end
  end

  def bignum_to_bytes(d)
    s = String.new
    while (d != 0)
      s << (d & 0xFF)
      d >>= 8
    end
    s.reverse!
  end

  def add(d)
    case d
    when Integer
      ib = if d < 0
             d = -1-d
             0x20
           else
             0x00
           end
      head(ib, d) {             # block is called if things do not fit
        s = bignum_to_bytes(d)
        head(0xc0, TAG_BIGNUM_BASE + (ib >> 5))
        head(0x40, s.bytesize)
        s
      }
    when Numeric; addfloat(d)
    when Symbol; add(d.to_s)    # hack: this should really be tagged
    when Simple; head(0xe0, d.value)
    when false; head(0xe0, 20)
    when true; head(0xe0, 21)
    when nil; head(0xe0, 22)
    when Tagged                 # we don't handle :simple here
      head(0xc0, d.tag)
      add(d.data)
    when String
      lengths = d.cbor_stream?
      e = d
      ib = if d.encoding == Encoding::BINARY
             0x40
           else
             d = d.encode(Encoding::UTF_8).force_encoding(Encoding::BINARY)
             0x60
           end
      if lengths
        @buffer << (ib + 31)
        pos = 0
        lengths.each do |r|
          add(e[pos, r])
          pos += r
        end
        @buffer << 0xff
      else
        head(ib, d.bytesize)
        @buffer << d
      end
    when Array
      if d.cbor_stream?
        @buffer << 0x9f
        d.each {|di| add(di)}
        @buffer << 0xff
      else
        head(0x80, d.size)
        d.each {|di| add(di)}
      end
    when Hash
      if d.cbor_stream?
        @buffer << 0xbf
        d.each {|k, v| add(k); add(v)}
        @buffer << 0xff
      else
        head(0xa0, d.size)
        d.each {|k, v| add(k); add(v)}
      end
    else
      raise("Don't know how to encode #{d.inspect}")
    end
    self
  end

  def take(n)
    opos = @pos
    @pos += n
    raise "Out of bytes to decode: #{opos} + #{n} > #{@buffer.bytesize}" if @pos > @buffer.bytesize
    @buffer[opos, n]
  end

  MT_TO_ENCODING = {2 => Encoding::BINARY, 3 => Encoding::UTF_8}

  def decode_item_streaming(ib, breakable)
    case ib >>= 5
    when 2, 3
      want_encoding = MT_TO_ENCODING[ib]
      subs = []
      while (element = decode_item(true)) != BREAK
        raise "non-string (#{element.inspect}) in streaming string" unless String === element
        raise "bytes/text mismatch (#{element.encoding} != #{want_encoding}) in streaming string" unless element.encoding == want_encoding
        subs << element
      end
      result = subs.join.cbor_stream!(subs.map(&:length)).force_encoding(want_encoding)
    when 4
      result = Array.new;
      while (element = decode_item(true)) != BREAK
        result << element
      end
      result
    when 5
      result = Hash.new
      while (key = decode_item(true)) != BREAK
        result[key] = decode_item
      end
      result
    when 7
      raise "break stop code outside indefinite length item" unless breakable
      BREAK
    else raise "unknown ib #{ib} for additional information 31"
    end
  end
  
  def decode_item(breakable = false)
    ib = take(1).ord
    ai = ib & 0x1F
    val = case ai
          when 0...24; ai
          when 24; take(1).ord
          when 25; take(2).unpack("n").first
          when 26; (s = take(4)).unpack("N").first
          when 27; (s = take(8)).unpack("Q>").first
          when 31; return decode_item_streaming(ib, breakable)
          else raise "unknown additional information #{ai} in ib #{ib}"
          end
    case ib >>= 5
    when 0; val
    when 1; -1-val
    when 7
      case ai
      when 20; false
      when 21; true
      when 22; nil
      # when 27; Simple.new(27)   # Ruby does not have Undefined
      when 25; Half.decode(val)
      when 26; s.unpack("g").first # cannot go directly from val
      when 27; s.unpack("G").first #   in Ruby
      else
        Simple.new(val)
      end
    when 6
      di = decode_item
      if String === di && (val & ~1) == TAG_BIGNUM_BASE
        (TAG_BIGNUM_BASE - val) ^ di.bytes.inject(0) {|sum, b| sum <<= 8; sum += b }
      else
        Tagged.new(val, di)
      end
    when 2; take(val).force_encoding(Encoding::BINARY)
    when 3; take(val).force_encoding(Encoding::UTF_8)
    when 4; Array.new(val) { decode_item }
    when 5; Hash[Array.new(val) {[decode_item, decode_item]}]
    end
  end

  def decode_item_final
    val = decode_item
    raise "extra bytes follow after a deserialized object" if @pos != @buffer.size
    val
  end

end
