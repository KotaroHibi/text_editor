require './content'
class ContentArray < Content
  # 配列の添字が行、各行は文字列
  # rubyでは文字列に対して配列のような位置を指定した操作ができる
  def initialize(content = '')
    if content.is_a?(Array)
      @content = content
    else
      @content = [content]
    end
  end

  def get_char(row, col)
    @content[row][col]
  end

  def get_string(row, col, count)
    @content[row][col, count]
  end

  def get_line(row)
    @content[row]
  end

  def rows
    @content.size
  end

  def insert_char(char, row, col)
    line = get_line(row)
    line[col, 0] = char
    @content[row] = line
  end

  def insert_string(str, row, col)
    line = get_line(row)
    line[col, 0] = str
    @content[row] = line
  end

  def replace_char(char, row, col)
    line = get_line(row)
    line[col] = char
    @content[row] = line
  end

  def replace_string(str, row, col)
    line       = get_line(row)
    line[col, str.length] = str
    @content[row] = line
  end

  def add_line(row)
    @content[(row + 1), 0] = ''
  end

  def change_line(row, col)
    line   = get_line(row)
    line1 = line[0, col]
    line2 = line[col, (line.length - col)]
    @content[row] = line1
    @content[(row + 1), 0] = line2
  end

  def delete_line(row)
    @content.slice!(row)
    @content = [''] if @content.size == 0
  end

  def to_string
    @content.join("\n")
  end

  def delete_char(count, row, col)
    line = get_line(row)
    if count > 0
      # 配列のサイズからオーバーした分は無視されるのでオーバー分は気にしない
      line[col, count] = ''
    else
      unless (col - count.abs) < 0
        line[(col - count.abs), count.abs] = ''
      end
    end
  end

  def merge_line(count, row)
    # とりあえず1行
    return if (row - 1) < 0
    line = get_line(row)
    col  = @content[row - 1].length
    @content[row - 1] << line
    @content.slice!(row, 1)
  end
end
