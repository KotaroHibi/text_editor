class List
  class Node
    attr_accessor :id, :prev, :next, :body
    def initialize
      @id   = nil
      @next = nil
      @prev = nil
      @body = nil
    end
  end

  def initialize
    @list     = Hash.new
    @sequence = 1
    @current  = nil
    @first    = nil
    @last     = nil
  end

  def add(body=nil)
    node = Node.new
    node.id   = @sequence
    node.body = body
    if @list.count == 0
      @current = node.id
      @first   = node.id
    else
      last_node = @list[@last]
      last_node.next = node.id
      node.prev = last_node.id
    end
    @list[node.id] = node
    @last = node.id
    @sequence += 1
  end

  def delete(id)
    node = @list[id]
    return if node.nil?
    prev_node = node.prev.nil? ? nil : @list[node.prev]
    next_node = node.next.nil? ? nil : @list[node.next]
    unless prev_node.nil?
      prev_node.next = next_node.nil? ? nil : next_node.id
    end
    unless next_node.nil?
      next_node.prev = prev_node.nil? ? nil : prev_node.id
    end
    adjust_position(id)
    @list.delete(id)
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
    return node if node.body.instance_variable_get("@#{attribute}") == value
    until node.next.nil?
      node = @list[node.next]
      return node if node.body.instance_variable_get("@#{attribute}") == value
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

  def [](id)
    @list[id]
  end

  private
  def adjust_position(id)
    node = @list[id]
    return if node.nil?
    if id == @current
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
    @first = node.next if id == @first
    @last  = node.prev if id == @last
  end
end
