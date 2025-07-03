class CBOR_DIAG::AppParseError < ArgumentError
  attr_accessor :position
  def initialize(msg, pos)
    @position = pos
    super(msg)
  end
end
