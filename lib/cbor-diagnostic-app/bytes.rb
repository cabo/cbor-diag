require 'cbor-deterministic'

class CBOR_DIAG::App_bytes
  def self.decode(_, s)
    a = if CBOR::Sequence === s
          s.elements
        else
          [s]
        end
    a.map { |el|
      unless String === el
        raise ArgumentError.new("cbor-diagnostic: bytes<<#{a.cbor_diagnostic[1...-1]}>>: #{el.cbor_diagnostic} not a string: Argument Error")
      end
      el.b
    }.join.b # .b needed so empty array becomes byte string, too
  end
end
