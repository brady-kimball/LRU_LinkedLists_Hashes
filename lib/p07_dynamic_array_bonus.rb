require 'byebug'

class StaticArray

  def initialize(capacity)
    @store = Array.new(capacity)
  end

  def [](i)
    validate!(i)
    @store[i]
  end

  def []=(i, val)
    validate!(i)
    @store[i] = val
  end

  def length
    @store.length
  end

  private

  def validate!(i)
    raise "Overflow error" unless i.between?(0, @store.length - 1)
  end
end

class DynamicArray
  include Enumerable

  attr_reader :count

  def initialize(capacity = 8)
    @store = StaticArray.new(capacity)
    @count = 0
  end

  def last_index
    i = capacity - 1
    while i >= 0 && self[i].nil?
      i -= 1
    end
    i < 0 ? nil : i
  end

  def [](i)
    if i < 0
      idx = last_index + 1 + i
      idx < 0 ? nil : @store[idx]
    else
      @store[i]
    end
  rescue
    nil
  end

  def []=(i, val)
    if self[i].nil?
      @count += 1
    end
    until i < capacity
      resize!
    end

    if i < 0
      idx = last_index + 1 + i
      self[idx] = val
    else
      @store[i] = val
    end
  end

  def capacity
    @store.length
  end

  def include?(val)
    i = 0
    until self[i].nil?
      return true if self[i] == val
      i += 1
    end
    false
  end

  def push(val)
    i = 0
    until self[i] == nil
      i += 1
    end
    self[i] = val
  end

  def unshift(val)
    old_store = @store
    @count = 0
    @store = StaticArray.new(capacity + 1)
    self[0] = val
    i = 0
    until old_store[i] == nil
      self[i + 1] = old_store[i]
      i += 1
    end
  end

  def pop
    i = 0
    until self[i + 1].nil?
      i += 1
    end
    @count -= 1
    popped = self[i]
    self[i] = nil
    popped
  end

  def shift
    old_store = @store
    last_i = last_index
    return nil if last_i.nil?
    @count = 0
    @store = StaticArray.new(capacity)
    i = 1
    until i == last_i + 1
      self[i - 1] = old_store[i]
      i += 1
    end
    old_store[0]
  end

  def first
    self[0]
  end

  def last
    i = 0
    until self[i + 1] == nil
      i += 1
    end
    self[i]
  end

  def each
    i = 0
    until i == capacity
      yield(@store[i])
      i += 1
    end
    self
  end

  def to_s
    "[" + inject([]) { |acc, el| acc << el }.join(", ") + "]"
  end

  def ==(other)
    return false unless [Array, DynamicArray].include?(other.class)
    i = 0
    until i == last_index + 1
      return false unless self[i] == other[i]
      i += 1
    end
    true
  end

  alias_method :<<, :push
  [:length, :size].each { |method| alias_method method, :count }

  private

  def resize!
    @count = 0
    new_store = StaticArray.new(capacity * 2)
    self.each_with_index do |num, i|
      new_store[i] = num
    end
    @store = new_store
  end
end

if __FILE__ == $PROGRAM_NAME
  a = DynamicArray.new
  a[15] = 7
end
