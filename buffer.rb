class Buffer
  require './point'

  attr_accessor :name, :is_modified
  attr_reader :start, :end, :file_name, :contents, :num_chars, :num_lines, :point
  def initialize(name)
    @name = name
    # @contents$B$O$H$j$"$($:0l<!85G[Ns(B($B$h$jNI$$9=B$$r9M$($k(B)
    # $BG[Ns$NE:;z$,9T!"3F9T$OJ8;zNs(B
    # ruby$B$G$OJ8;zNs$KBP$7$FG[Ns$N$h$&$J0LCV$r;XDj$7$?A`:n$,$G$-$k(B
    @contents = ['']
    @point = Point.new
    @is_modified = false
    @num_chars = 0
    @num_lines = 1
  end

  def get_char
    @contents[@point.row][@point.col]
  end

  def get_string(count)
    @contents[@point.row][@point.col, count]
  end

  def insert_char(char)
    line = @contents[@point.row]
    line[@point.col, 0] = char
    @contents[@point.row] = line
    move_point(1)
    @num_chars += 1
    @is_modified = true
    true
  end

  def insert_string(str)
    line = @contents[@point.row]
    line[@point.col, 0] = str
    @contents[@point.row] = line
    move_point(str.length)
    @num_chars += str.length
    @is_modified = true
    true
  end

  def replace_char(char)
    line = @contents[@point.row]
    line[@point.col] = char
    @contents[@point.row] = line
    @is_modified = true
    true
  end

  def replace_string(str)
    line       = @contents[@point.row]
    old_length = line.length
    line[@point.col, str.length] = str
    @contents[@point.row] = line
    diff = line.length - old_length
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
    open(@file_name, 'w') { |file| file.write(contents_to_file) }
    puts 'write'
  end

  def read
    return false if (@file_name.nil? || @file_name == '')
    return false if File.readable?(@file_name)
    @file_time = File.mtime(@file_name)
    open(@file_name) { |file| file_to_contents(file.readlines) }
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
    # $B0\F0@h$KJ8;z$,$J$1$l$P9T$NKvHx$K0\F0$9$k(B
    col  = @point.col + count
    line = @contents[@point.row]
    return @point.col if (col < 0 || col > line.length)
    @point.move_point(count)
    col
  end

  def move_line(count = 1)
    # $BJ8;z$,$J$1$l$P0\F0$7$J$$(B
    row = @point.row + count
    return @point.row if (row < 0 || row > (@contents.size - 1))
    # $B9T$r0\F0$7$?@h$KJ8;z$,$J$1$l$P0LCV$r9T$NKvHx$KJQ99(B
    line   = @contents[row]
    length = line.nil? ? 0 : line.length
    col    = @point.col
    col    = length if col > length
    @point.set_point(row, col)
    row
  end

  def add_line()
    # $B<B:]$O2~9T%3!<%I$,F~$C$?$H$-$K8F$S=P$9(B
    @contents[(@point.row + 1), 0] = ''
    @point.set_point((@point.row + 1), 0)
    @num_lines += 1
  end

  def change_line()
    line = @contents[@point.row]
    line1 = line[0, @point.col]
    line2 = line[@point.col, (line.length - @point.col)]
    @contents[@point.row] = line1
    @contents[(@point.row + 1), 0] = line2
    @point.set_point((@point.row + 1), 0)
    @num_lines += 1
  end

  def delete_line()
    line       = @contents[@point.row]
    old_length = line.length
    @contents.slice!(@point.row)
    if @contents.size == 0
      @contents = ['']
      row = 0
      col = 0
    else
      row  = @point.row
      row  = (@contents.size - 1) if @contents[@point.row].nil?
      line = @contents[row]
      col  = @point.col
      if line.nil?
        col = 0
      else
        col = line.length if line[col].nil?
      end
    end
    @point.set_point(row, col)
    @num_lines -= 1
    @num_chars -= old_length
    true
  end

  # private
  def file_to_contents(contents)
    @contents = contents
  end

  def contents_to_file
    @contents.join("\n")
  end

  def delete_char(count)
    line       = @contents[@point.row]
    old_length = line.length
    if count > 0
      # $BG[Ns$N%5%$%:$+$i%*!<%P!<$7$?J,$OL5;k$5$l$k$N$G%*!<%P!<J,$O5$$K$7$J$$(B
      line[@point.col, count] = ''
    else
      unless (@point.col - count.abs) < 0
        line[(@point.col - count.abs), count.abs] = ''
      end
    end
    diff = line.length - old_length
    @num_chars += diff
    move_point(diff)
    @is_modified = true
    true
  end

  def merge_line(count)
    # $B$H$j$"$($:(B1$B9T(B
    return if (@point.row - 1) < 0
    line       = @contents[@point.row]
    old_length = line.length
    col        = @contents[@point.row - 1].length
    @contents[@point.row - 1] << line
    @contents.slice!(@point.row, 1)
    # diff = -1
    # @num_chars += diff
    @point.set_point((@point.row - 1), col)
    @is_modified = true
    true
  end

end
