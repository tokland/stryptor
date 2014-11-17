class Struct
  def self.from_hash(hash)
    if !(missing_keys = members - hash.keys).empty?
      raise ArgumentError.new("Missing keys in hash: #{missing_keys}")
    elsif !(unknown_keys = hash.keys - members).empty?
      raise ArgumentError.new("Unknown keys in hash: #{unknown_keys}")
    else
      new(*hash.values_at(*members))
    end
  end
end
