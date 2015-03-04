# This should work with the C-ext cbor-ruby as well as with our cbor-pure
unless defined?(CBOR)
  require 'cbor-pure'
end

class Object
  def cbor_diagnostic
    inspect
  end
end

class NilClass
  def cbor_diagnostic
    "null"
  end
end

class Float
  def cbor_diagnostic           # do a little bit of JSON.stringify gaming (ECMA-262, 9.8.1)
    a = abs
    if a < 1 && a >= 1e-6
      inspect.sub(/(\d)[.](\d+)e-(\d+)/) {"0.#{"0" * ($3.to_i - 1)}#{$1}#{$2}"}
    else
      inspect.sub(/(e[+-])0+/) {$1}
    end
  end
end

raise unless 0.00006103515625.cbor_diagnostic == "0.00006103515625"
raise unless 0.99.cbor_diagnostic == "0.99"
raise unless 0.099.cbor_diagnostic == "0.099"
raise unless 0.0000099.cbor_diagnostic == "0.0000099"

class String
  unless String.instance_methods.include?(:b)
    def b
      dup.force_encoding(Encoding::BINARY)
    end
  end
  def hexbytes(sep = '')
    bytes.map{|x| "%02x" % x}.join(sep)
  end
  def cbor_diagnostic
    if lengths = cbor_stream?
      pos = 0
      "(_ #{lengths.map{|l| r = self[pos, l].cbor_diagnostic; pos += l; r}.join(", ")})"
    else
      if encoding == Encoding::BINARY
        "h'#{hexbytes}'"
      else
        inspect.encode(Encoding::UTF_16BE).bytes.each_slice(2).map {
          |c1, c2| c = (c1 << 8)+c2; c < 128 ? c.chr : '\u%04x' % c }.join
      end
    end
  end
end

class Array
  def cbor_diagnostic
    "[#{"_ " if cbor_stream?}#{map(&:cbor_diagnostic).join(", ")}]"
  end
end

class Hash
  def cbor_diagnostic
    "{#{"_ " if cbor_stream?}#{map{ |k, v| %{#{k.cbor_diagnostic}: #{v.cbor_diagnostic}}}.join(", ")}}"
  end
end

class CBOR::Tagged
  def cbor_diagnostic
    "#{tag}(#{data.cbor_diagnostic})"
  end
end
