require 'cbor-transform'
unless defined?(JSON)
  require 'json'
end
require 'base64'

class CBOR::Transform_j < CBOR::Transform

  # CBOR::Transform_j.new(1).transform [1, "a", "b".b, CBOR::Simple.new(2), CBOR::Tagged.new(1, 2), {"a"=> 1, 2=> 3}]

  def transform_simple(obj)
    {'@@!s': obj.value}
  end

  def transform_bytes(obj)
    {'@@!b': ::Base64.urlsafe_encode64(obj, padding: false)}
  end

  def transform_hash(obj)
    Hash[obj.map {|k, v| [ (
                             kt = transform(k)
                             if (String === kt && kt.encoding != Encoding::BINARY)
                               kt
                             else
                               '@@!:' << JSON.generate(kt)
                             end
                           ),
                           transform(v)]}]
  end

  def transform_tag(obj)
    {"@@!t#{obj.tag}": transform(obj.value)}
  end

end

class CBOR::Transform_jr < CBOR::Transform

  # >> CBOR::Transform_jr.new(1).transform(JSON.parse(JSON.generate(a = CBOR::Transform_j.new(1).transform([1, "a", "b".b, CBOR::Simple.new(2), CBOR::Tagged.new(1, 2), {"a"=> 1, 2=> 3, {3=>4}=>5}]))))
  # => [1, "a", "b", #<struct CBOR::Simple value=2>, #<struct CBOR::Tagged tag=1, value=2>, {"a"=>1, 2=>3, {3=>4}=>5}]
  # >> a
  # => [1, "a", {:"@@!b"=>"Yg"}, {:"@@!s"=>2}, {:"@@!t1"=>2}, {"a"=>1, "@@!:2"=>3, "@@!:{\"@@!:3\":4}"=>5}]

  def transform_hash(obj)
    if obj.size == 1 && obj.keys.first =~ /\A@@!([a-z].*)/
      cookie = $1
      value = obj.values.first
      case cookie
      when "s"
        CBOR::Simple.new(value)
      when "b"
        ::Base64.urlsafe_decode64(value)
      when /\At(\d+)\z/
        CBOR::Tagged.new($1.to_i, transform(value))
      else
        fail ArgumentError.new("Unknown CBOR-JSON encoding @@!#{cookie}")
      end
    else
      Hash[obj.map {|k, v| [ transform(
                               if k =~ /\A@@!:(.*)\z/
                                 JSON.parse($1)
                               else
                                 k
                               end), transform(v)]}]
    end
  end

end
