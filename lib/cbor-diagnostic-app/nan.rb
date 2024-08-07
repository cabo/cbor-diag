require 'scanf'

class CBOR_DIAG::App_nan
  def self.decode(_, s)
    val, = s.sub("p0", "p+0").scanf("%a")
    raise ArgumentError.new ("nan'#{s}' not valid") unless val &&
                                                           val.abs > 1.0 && val.abs < 2.0
    val.cbor_nan_toggle
  end
end
