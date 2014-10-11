require './curses_api'
class Cursor
  attr_accessor :row, :col
  def initialize
    @row = 0
    @col = 0
  end

  def set_position(row, col)
    @row = row
    @col = col
    CursesAPI::setpos(row, col)
  end
end
