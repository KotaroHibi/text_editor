class NamedList
  class Node
    attr_accessor :name, :prev, :next, :body
    def initialize
      @name = nil
      @next = nil
      @prev = nil
      @body = nil
    end
  end

  def initialize
    @list    = Hash.new
    @current = nil
    @first   = nil
    @last    = nil
  end

  def add(name, body=nil)
    return false if @list.key?(name)
    node = Node.new
    node.name = name
    node.body = body
    if @list.count == 0
      @current = node.name
      @first   = node.name
    else
      last_node = @list[@last]
      last_node.next = node.name
      node.prev = last_node.name
    end
    @list[node.name] = node
    @last = node.name
    true
  end

  def delete(name)
    node = @list[name]
    return false if node.nil?
    prev_node = node.prev.nil? ? nil : @list[node.prev]
    next_node = node.next.nil? ? nil : @list[node.next]
    unless prev_node.nil?
      prev_node.next = next_node.nil? ? nil : next_node.name
    end
    unless next_node.nil?
      next_node.prev = prev_node.nil? ? nil : prev_node.name
    end
    adjust_position(name)
    @list.delete(name)
    true
  end

  def fetch
    return nil if @first.nil?
    nodes = []
    node = @list[@first]
    nodes << node
    until node.next.nil?
      node = @list[node.next]
      nodes << node
    end
    nodes
  end

  def findByAttribute(attribute, value)
    return nil if @first.nil?
    nodes = []
    node = @list[@first]
    return node.body if node.body.instance_variable_get("@#{attribute}") == value
    until node.next.nil?
      node = @list[node.next]
      return node.body if node.body.instance_variable_get("@#{attribute}") == value
    end
    nil
  end

  def current
    @list[@current]
  end

  def next
    node = @list[@current]
    return nil if node.nil? || node.next.nil?
    @current = node.next
    @list[node.next]
  end

  def prev
    node = @list[@current]
    return nil if node.nil? || node.prev.nil?
    @current = node.prev
    @list[node.prev]
  end

  def first
    @list[@first]
  end

  def last
    @list[@last]
  end

  def [](name)
    @list[name]
  end

  def set_current(name)
    return nil unless @list.key?(name)
    @current = name
    current
  end

  def set_next
    next_node = self.next
    return nil if next_node.nil?
    next_node.name
  end

  def get_body(name)
    return nil unless exist?(name)
    @list[name].body
  end

  def exist?(name)
    @list.key?(name)
  end

  private
  def adjust_position(name)
    node = @list[name]
    return if node.nil?
    if name == @current
      unless node.next.nil?
        @current = node.next
      else
        unless node.prev.nil?
          @current = node.prev
        else
          @current = nil
        end
      end
    end
    @first = node.next if name == @first
    @last  = node.prev if name == @last
  end
end
