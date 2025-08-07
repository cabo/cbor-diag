class CBOR_DIAG::App_float
  SIZES = {
    2 => "\xf9".b.freeze,
    4 => "\xfa".b.freeze,
    8 => "\xfb".b.freeze,
  }

  def self.decode(_, s)
    if CBOR::Sequence === s
      if s.elements.size != 1
        raise ArgumentError.new("cbor-diagnostic: float<< #{s.inspect[1...-1]} >>: Argument Error")
      end
      s = s.first
    end
    unless String === s
      raise ArgumentError.new("cbor-diagnostic: float<< #{s.inspect} >>: Argument Error")
    end
    if s.encoding != Encoding::BINARY
      s = s.gsub(/\s/, "").chars.each_slice(2).map{ |x| Integer(x.join, 16).chr("BINARY") }.join
    end
    ssize = SIZES[s.size]
    unless ssize
      raise ArgumentError.new("cbor-diagnostic: float<< #{s.inspect} >> size #{s.size} mismatch: Argument Error")
    end
    CBOR::decode(ssize + s)
  end
end
