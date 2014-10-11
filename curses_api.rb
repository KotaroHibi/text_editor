require 'curses'
class CursesAPI
  class << self
    def init
      Curses.init_screen
      Curses.cbreak
      Curses.noecho
    end

    def close_screen
      Curses.close_screen
    end

    def clear
      Curses.clear
    end

    def getch
      Curses.getch
    end

    def insch(char)
      Curses.insch(char)
    end

    def addstr(str)
      Curses.addstr(str)
    end

    def delch(count)
      count.times { Curses.delch }
    end

    def insertln
      Curses.insertln
    end

    def deleteln
      Curses.deleteln
    end

    def setpos(y, x)
      Curses.setpos(y, x)
    end

    def changeln(line1, line2, y)
      deleteln
      setpos(y, 0)
      insertln
      addstr(line1)
      setpos((y + 1), 0)
      insertln
      addstr(line2)
    end

  end
end
