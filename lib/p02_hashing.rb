class Fixnum
  # Fixnum#hash already implemented for you
end

class Array
  def hash
    if self.flatten.empty?
      a = self
      b = 0
      until a[0].nil?
        b += 1
        a = a[0]
      end
      return b.hash
    end
    
    index_hash = self.flatten.map.with_index do |num, i|
      (num.hash ^ i.hash).hash
    end
    index_hash.reduce(&:+)
  end
end

class String
  def hash
    self.chars.map(&:bytes).flatten.hash
  end
end

class Hash
  # This returns 0 because rspec will break if it returns nil
  # Make sure to implement an actual Hash#hash method
  def hash
    self.to_a.sort_by(&:hash).hash
  end
end
