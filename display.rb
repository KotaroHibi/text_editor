require './window'
require './screen'
class Display
  attr_accessor :attributes, :keyboard
  def initialize
    @window_list = []
    @screen = Screen.new
    CursesAPI::init
    true
  end

  def finish
    CursesAPI::close_screen
    true
  end

  def clear_screen
    CursesAPI::clear
  end

  def save
    true
  end

  def load
    true
  end

  def create_window(buffer)
    window = Window.new(buffer)
    @window_list << window
    window
  end

  def redisplay
    clear_screen
    @window_list.each do |window|
      buffer   = window.buffer
      contents = buffer.content.content
      for i in 0..contents.size do
        window.cursor.set_position(i, 0)
        insert_string(contents[i]) unless contents[i].nil?
      end
      window.cursor.set_position(buffer.point.row, buffer.point.col)
    end
  end

  def insert_string(str)
    CursesAPI::addstr(str)
  end
end
