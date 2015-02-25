# -*- coding: utf-8 -*-
#
# 16-bit floating point values (IEEE 754 Half Precision) are not
# supported by #pack/#unpack in Ruby yet.
# This is a quick hack implementing en- and decoding them.
# (Since this is just a hack, the brief tests are in this file.)
#
# The encoder assumes that we already have a Single-Precision byte
# string (e.g., from pack("g")), and this is taken apart and
# reassembled.
# The decoder is free-standing (trivial).
#
# IEEE 754 can be found at:
# http://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=4610935

module Half
  NAN_BYTES = "\x7e\x00"

  def self.decode_from_bytes(hs)
    b16, = hs.unpack("n")
    self.decode(b16)
  end
  def self.decode(b16)
    exp = b16 >> 10 & 0x1f
    mant = b16 & 0x3ff
    val =
      if exp == 0
        Math.ldexp(mant, -24)
      elsif exp == 31
        mant == 0 ? Float::INFINITY : Float::NAN
      else
        Math.ldexp(0x400 + mant, exp-25)
      end
    if b16[15] != 0
      -val
    else
      val
    end
  end

  def self.encode_from_single_bytes(ss)        # single-precision string
    b32, = ss.unpack("N")
    s16 = b32 >> 16 & 0x8000
    mant = b32 & 0x7fffff
    exp = b32 >> 23 & 0xff
    # puts "#{fv} #{s16} #{mant.to_s(16)} #{exp}"
    if exp == 0
      s16 if mant == 0            # 0.0, -0.0
    elsif exp >= 103 && exp < 113 # denorm, exp16 = 0
      s16 + ((mant + 0x800000) >> (126 - exp))
    elsif exp >= 113 && exp <= 142 # normalized
      s16 + ((exp - 112) << 10) + (mant >> 13)
    elsif exp == 255              # Inf (handle NaN elsewhere!)
      s16 + 0x7c00 if mant == 0   # +Inf/-Inf
    end
  end

  def self.encode_from_single(fv, ss)
    if e = self.encode_from_single_bytes(ss)
      # p e.to_s(16)
      hs = [e].pack("n")
      hs if self.decode_from_bytes(hs) == fv
    end
  end

  def self.encode(fv)
    self.encode_from_single(fv, [fv].pack("g"))
  end
  
end

(-24..15).each do |i|
  f = Math.ldexp(1, i)
  s = Half.encode(f)
  fail i unless s
end
(-24..6).each do |i|
  f = Math.ldexp(1023, i)
  s = Half.encode(f)
  fail i unless s
end

# p Half.decode("\x7b\xff") 65504.0

[                               # go through Wikipedia samples
0b0_01111_0000000000, 1.0,
0b0_01111_0000000001, 1.0 + Math.ldexp(1, -10), # = 1 + 2−10 = 1.0009765625 (next biggest float after 1)
0b1_10000_0000000000, -2.0,

0b0_11110_1111111111, 65504.0, #  (max half precision)

0b0_00001_0000000000, Math.ldexp(1, -14), # ≈ 6.10352 × 10−5 (minimum positive normal)
0b0_00000_1111111111, Math.ldexp(1, -14) - Math.ldexp(1, -24), # ≈ 6.09756 × 10−5 (maximum subnormal)
0b0_00000_0000000001, Math.ldexp(1, -24), # ≈ 5.96046 × 10−8 (minimum positive subnormal)

0b0_00000_0000000000, 0.0,
0b1_00000_0000000000, -0.0,

0b0_11111_0000000000, 1.0/0.0,
0b1_11111_0000000000, -1.0/0.0,

0b0_01101_0101010101, 0.333251953125 #... ≈ 1/3 
].each_slice(2) do |hv, expected|
  fv = Half.decode(hv)
  raise [hv, fv, expected].inspect unless fv == expected
end

# NaN cannot be compared, so this one needs to be special-cased:
raise "NaN not detected" unless Half.decode(0b0_11111_1000000000).nan?
raise "-NaN not detected" unless Half.decode(0b1_11111_1000000000).nan?
raise "NaN not detected" unless Half.decode_from_bytes(Half::NAN_BYTES).nan?
