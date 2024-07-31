class Float
  def cbor_nan_toggle               # precondition: 1.0 < |self| < 2.0 or nan?
    a = [self].pack("G")
    a.setbyte(0, a.getbyte(0) ^ 0x40)
    a.unpack("G").first
  end
end
