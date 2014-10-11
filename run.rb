require './editor'
require './curses_api'
require './display'
require './keyboard'
require './command'
require 'yaml'
require 'pp'

# 初期化
ed = Editor.new
ed.create_buffer('1')
ed.set_current_buffer('1')
di = Display.new
di.create_window(ed.current_buffer)
co = Command.new(ed, di)

# コアループ
while true
  input = Keyboard::get_key
  co.evaluate(input)
  di.redisplay
end
di.finish
