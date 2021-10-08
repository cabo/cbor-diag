class CBOR::Transform

  def transform(obj)
    case obj
    when NilClass
      transform_nil(obj)
    when FalseClass, TrueClass
      transform_bool(obj)
    when CBOR::Simple
      transform_simple(obj)
    when Float
      transform_float(obj)
    when Integer
      transform_integer(obj)
    # XXX should probably handle Symbol
    when String
      case obj.encoding
      when Encoding::BINARY
        transform_bytes(obj)
      else
        transform_text(obj)
      end
    when Array
      transform_array(obj)
    when Hash
      transform_hash(obj)
    when CBOR::Tagged
      transform_tag(obj)
    end
  end

  def transform_nil(obj)
    obj
  end

  def transform_bool(obj)
    obj
  end

  def transform_simple(obj)
    obj
  end

  def transform_float(obj)
    obj
  end

  def transform_integer(obj)
    obj
  end

  def transform_bytes(obj)
    obj
  end

  def transform_text(obj)
    obj
  end

  def transform_array(obj)
    obj.map {|x| transform(x)}
  end

  def transform_hash(obj)
    Hash[obj.map {|k, v| [transform(k), transform(v)]}]
  end

  def transform_tag(obj)
    CBOR::Tagged.new(transform(obj.tag), transform(obj.value))
  end

end
