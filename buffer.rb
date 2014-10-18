class Buffer
  require './point'
  require './content'
  require './content_array'
  require './content_list'

  attr_accessor :name, :is_modified
  attr_reader :start, :end, :file_name, :content, :num_chars, :num_lines, :point
  def initialize(name)
    @name = name
    # @contentはとりあえず一次元配列(より良い構造を考える)
    # @contentのデータ構造を切り替えやすいように別クラスにしておく
    @content = ContentArray.new
    # @content = ContentList.new
    @point = Point.new
    @is_modified = false
    @num_chars = 0
    @num_lines = 1
  end

  def get_char
    @content.get_char(@point.row, @point.col);
  end

  def get_string(count)
    @content.get_string(@point.row, @point.col, count)
  end

  def insert_char(char)
    @content.insert_char(char, @point.row, @point.col)
    move_point(1)
    @num_chars += 1
    @is_modified = true
    true
  end

  def insert_string(str)
    @content.insert_string(str, @point.row, @point.col)
    move_point(str.length)
    @num_chars += str.length
    @is_modified = true
    true
  end

  def replace_char(char)
    @content.replace_char(char, @point.row, @point.col)
    @is_modified = true
    true
  end

  def replace_string(str)
    old_line   = @content.get_line(@point.row)
    old_length = old_line.length
    @content.replace_string(str, @point.row, @point.col)
    new_line   = @content.get_line(@point.row)
    diff = new_line.length - old_length
    @num_chars += diff
    move_point(diff)
    @is_modified = true
    true
  end

  def delete(count)
    if count < 0 && (@point.col - count.abs) < 0
      merge_line(count)
    else
      delete_char(count)
    end
  end

  def file_name=(val)
    return false if File.exist?(val)
    @file_name = val
  end

  def write
    return false if (@file_name.nil? || @file_name == '')
    return false if File.writable?(@file_name)
    open(@file_name, 'w') { |file| file.write(content_to_file) }
    puts 'write'
  end

  def read
    return false if (@file_name.nil? || @file_name == '')
    return false if File.readable?(@file_name)
    @file_time = File.mtime(@file_name)
    open(@file_name) { |file| file_to_content(file.readlines) }
    puts 'read'
  end

  def modified?
    @is_modified
  end

  def clear
    puts 'clear'
    true
  end

  def buffer_delete
    puts 'delete'
    clear
    true
  end

  def move_point(count = 1)
    # 移動先に文字がなければ行の末尾に移動する
    col  = @point.col + count
    line = @content.get_line(@point.row)
    return @point.col if (col < 0 || col > line.length)
    @point.move_point(count)
    col
  end

  def move_line(count = 1)
    # 文字がなければ移動しない
    row = @point.row + count
    return @point.row if (row < 0 || row > (@content.rows - 1))
    # 行を移動した先に文字がなければ位置を行の末尾に変更
    line   = @content.get_line(row)
    length = line.nil? ? 0 : line.length
    col    = @point.col
    col    = length if col > length
    @point.set_point(row, col)
    row
  end

  def add_line()
    # 実際は改行コードが入ったときに呼び出す
    @content.add_line
    @point.set_point((@point.row + 1), 0)
    @num_lines += 1
  end

  def change_line()
    @content.change_line(@point.row, @point.col)
    @point.set_point((@point.row + 1), 0)
    @num_lines += 1
  end

  def delete_line()
    old_line   = @content.get_line(@point.row)
    old_length = old_line.length
    @content.delete_line(@point.row)
    if @content.rows == 0
      row = 0
      col = 0
    else
      row      = @point.row
      row      = (@content.rows - 1) if @content.get_line(@point.row).nil?
      col      = @point.col
      new_line = @content.get_line(row)
      if new_line.nil?
        col = 0
      else
        col = new_line.length if new_line[col].nil?
      end
    end
    @point.set_point(row, col)
    @num_lines -= 1
    @num_chars -= old_length
    true
  end

  # private
  def file_to_content(content)
    @content = ContentArray.new(content)
  end

  def content_to_file
    @content.to_string
  end

  def delete_char(count)
    old_line   = @content.get_line(@point.row)
    old_length = old_line.length
    @content.delete_char(count, @point.row, @point.col)
    new_line   = @content.get_line(@point.row)
    diff = new_line.length - old_length
    @num_chars += diff
    move_point(diff)
    @is_modified = true
    true
  end

  def merge_line(count)
    # とりあえず1行
    return if (@point.row - 1) < 0
    @content.merge_line(count, @point.row)
    col = @content.get_line(@point.row - 1).length
    @point.set_point((@point.row - 1), col)
    @is_modified = true
    true
  end
end
