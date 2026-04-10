require 'cbor-deterministic'

class CBOR_DIAG::App_bytes
  def self.decode(_, s)
    if CBOR::Sequence === s
      a = s.elements
    else
      a = [s]
    end
    if a.detect { |el| not String === el }
      raise ArgumentError.new("cbor-diagnostic: bytes<<#{a.cbor_diagnostic[1...-1]}>>: not all strings: Argument Error")
    end
    a.join.b
  end
end
