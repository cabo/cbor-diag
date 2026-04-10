require 'cbor-deterministic'

class CBOR_DIAG::App_same
  def self.decode(_, s)
    if CBOR::Sequence === s
      a = s.elements
    else
      a = [s]
    end
    unless a.size > 0
      raise ArgumentError.new("cbor-diagnostic: same<< #{a.inspect[1...-1]} >>: Argument Error")
    end
    v1 = a.first
    e1 = v1.to_deterministic_cbor
    a[1..-1].each do |v2|
      unless v2.to_deterministic_cbor == e1
        raise ArgumentError.new("cbor-diagnostic: same<<>>: #{v1.cbor_diagnostic} not same as #{v2.cbor_diagnostic}: Argument Error")
      end
    end
    v1
  end
end
