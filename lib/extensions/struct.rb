class Struct
  def self.from_hash(hash)
    keys, values = hash.to_a.transpose
    Struct.new(*keys).new(*values)
  end
end
