require 'byebug'

class Link
  attr_accessor :key, :val, :next, :prev

  def initialize(key = nil, val = nil)
    @key = key
    @val = val
    @next = nil
    @prev = nil
  end

  def to_s
    "#{@key}: #{@val}"
  end

  def remove
    # optional but useful, connects previous link to next link
    # and removes self from list.
  end
end

class LinkedList
  include Enumerable

  attr_reader :head
  def initialize
    @head = Link.new(:head)
    @tail = Link.new(:tail)
    @head.next = @tail
    @tail.prev = @head
  end

  def [](i)
    each_with_index { |link, j| return link if i == j }
    nil
  end

  def first
    @head.next
  end

  def last
    @tail.prev
  end

  def empty?
    @head.next.key == :tail
  end

  def get(key)
    return nil unless include?(key)
    link = first
    until link.key == key
      link = link.next
    end
    link.val
  end

  def include?(key)
    link = @head
    until link.next == @tail
      link = link.next
      return true if link.key == key
    end
    false
  end

  def append(key, val)
    new_link = Link.new(key, val)
    prev_last = @tail.prev
    prev_last.next = new_link
    new_link.prev = prev_last
    new_link.next = @tail
    @tail.prev = new_link
  end

  def update(key, val)
    return unless include?(key)
    link = first
    until link.key == key
      link = link.next
    end
    link.val = val
  end

  def remove(key)
    return unless include?(key)
    link = first
    until link.key == key
      link = link.next
    end
    prev_link = link.prev
    next_link = link.next
    prev_link.next = next_link
    next_link.prev = prev_link
  end

  def each
    link = @head
    until link.next == @tail
      link = link.next
      yield(link)
    end
    self
  end

  # uncomment when you have `each` working and `Enumerable` included
  def to_s
    inject([]) { |acc, link| acc << "[#{link.key}, #{link.val}]" }.join(", ")
  end
end
