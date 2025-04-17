require 'digest'

class CBOR_DIAG::App_hash
  HASHES = {
    -14 => Digest::SHA1,
    "SHA-1" => Digest::SHA1,
    -16 => Digest::SHA256,
    "SHA-256" => Digest::SHA256,
    -43 => Digest::SHA384,
    "SHA-384" => Digest::SHA384,
    -44 => Digest::SHA512,
    "SHA-512" => Digest::SHA512,
  }

  def self.decode(_, s)
    if CBOR::Sequence === s
      args = s.elements
    else
      args = [s]
    end
    case args
    in [String]
      args[1] = -16             # default SHA-256
    in [String, Integer | String]
    else
      raise ArgumentError.new("cbor-diagnostic: hash<< #{args.inspect[1...-1]} >>: Argument Error")
    end
    fn = HASHES[args[1]]
    if fn
      fn.digest(args[0])
    else
      raise ArgumentError.new("cbor-diagnostic: hash<<>>: unimplemented hash function #{args[1]}")
    end
  end
end
