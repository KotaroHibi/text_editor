class Editor
  require './buffer'
  require './named_list'

  attr_accessor :current_buffer

  def initialize
    @buffer_chain = NamedList.new
    @curretn_buffer = nil
  end

  def init
    puts 'init'
  end

  def finish
    puts 'finish'
  end

  def save(file_name='')
    puts 'save'
  end

  def load(file_name='')
    puts 'load'
  end

  def create_buffer(name)
    buffer = Buffer.new(name)
    @buffer_chain.add(name, buffer)
  end

  def clear_buffer(name)
    buffer = @buffer_chain.get_body(name)
    return false if buffer.nil?
    buffer.clear
  end

  def delete_buffer(name)
    buffer = @buffer_chain.get_body(name)
    return false if buffer.nil?
    @buffer_chain.delete(name)
    if @buffer_chain.current.nil?
      # バッファがなくなったら終了する
    else
      @current_buffer = @buffer_chain.current.body
    end
    # できればバッファを削除
    # 自動でGCされるような気もするが
    # buffer.delete
    true
  end

  def set_current_buffer(name)
    return false unless @buffer_chain.exist?(name)
    @buffer_chain.set_current(name)
    @current_buffer = @buffer_chain.get_body(name)
    true
  end

  def set_buffer_next
    buffer_name = @buffer_chain.set_next
    return nil if buffer_name.nil?
    @current_buffer = @buffer_chain.get_body(buffer_name)
    buffer_name
  end

  def set_buffer_name(name)
    return false unless @buffer_chain.exist?(name)
    @current_buffer.name = name
    true
  end

  def get_buffer_name
    @current_buffer.name
  end
end
