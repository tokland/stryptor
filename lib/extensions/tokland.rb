module Enumerable
  def map_compact(&block)
    self.map(&block).compact
  end

  def mash(&block)
    self.inject({}) do |hash, item|
      if (result = block_given? ? yield(item) : item)
        key, value = (result.is_a?(Array) ? result : [item, result])
        hash.update(key => value)
      else
        hash
      end
    end
  end

  def map_select
    self.inject([]) do |acc, item|
      value = yield(item)
      value.nil? ? acc : acc << value
    end
  end
  
  def map_detect
    self.each do |member|
      if (result = yield(member))
        return result
      end
    end
    nil
  end
end

class String
  def split_at(idx)
    [self[0...idx], self[idx..-1]] 
  end
end

class Object
  def to_bool
    !!self
  end

  def whitelist(*valids)
    valids.include?(self) ? self : nil
  end

  def blacklist(*valids)
    valids.include?(self) ? nil : self
  end
  
  def send_if_responds(method_name, *args, &block)
    respond_to?(method_name) ? self.send(method_name, *args, &block) : nil
  end

  def or_else(options = {}, &block)
    if options[:if]
      self.send(options[:if]) ? yield : self
    else
      self || yield
    end
  end

  def state_loop(initial_value, &block)
    value = initial_value
    loop do
      value = (yield value) or break
    end
  end
  
  def as
    yield self
  end

  def in?(enumerable)
    enumerable.include?(self)
  end

  def not_in?(enumerable)
    !enumerable.include?(self)
  end
end
