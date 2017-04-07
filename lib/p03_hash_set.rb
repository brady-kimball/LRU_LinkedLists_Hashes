require_relative 'p02_hashing'

class HashSet
  attr_reader :count

  def initialize(num_buckets = 8)
    @store = Array.new(num_buckets) { Array.new }
    @count = 0
  end

  def insert(key)
    resize! if @count + 1 > num_buckets
    self[key.hash] << key unless include?(key)
    @count += 1
  end

  def include?(key)
    self[key.hash].include?(key)
  end

  def remove(key)
    self[key.hash].delete(key) if include?(key)
    key
  end

  private

  def [](num)
    # optional but useful; return the bucket corresponding to `num`
    @store[num % num_buckets]
  end

  def num_buckets
    @store.length
  end

  def resize!
    keys_to_add = @store.flatten
    @count = 0
    @array = Array.new(num_buckets * 2) { Array.new }
    keys_to_add.each do |key|
      insert(key)
    end
  end
end
