require 'uri'

class Params


  def initialize(req, route_params = {})
    @params = route_params
    if req.query_string
      @params.merge!(parse_www_encoded_form(req.query_string))
    end
    if req.body
      @params.merge!(parse_www_encoded_form(req.body))
    end
  end

  def [](key)
    @params[key.to_s]
  end

  def to_s
    @params.to_json.to_s
  end

  private
  # require 'uri'
  # uri = URI("http://www.bing.com/search?q=x")
  # URI::decode_www_form(uri.query)
  # this is shorter: "http://www.bing.com/search?q=x"
  def parse_www_encoded_form(www_encoded_form)
    params = Hash.new
    if www_encoded_form
      key_values = URI::decode_www_form(www_encoded_form)
      #[["key", "val"], ["key2", "val2"]]
      key_values.each do |arr|
        nested_keys = parse_key(arr[0])
        val = arr[1]
        while nested_keys.length > 0
          last_key = nested_keys.pop
          temp_hash = Hash.new
          temp_hash[last_key] = val
          val = temp_hash
        end
        # use deep_merge to combine these 2 temp hashes
        # {"user"=>{"address"=>{"street"=>"main"}}}
        # {"user"=>{"address"=>{"zip"=>"89436"}}}
        params = params.deep_merge(temp_hash)
      end
    end
    params
  end

  # this should return an array
  # user[address][street] should return ['user', 'address', 'street']
  def parse_key(key)
    key.split(/\]\[|\[|\]/)
  end
end
