class BufferCommand
  class << self
    def move_up
      @ed.current_buffer.move_line(-1)
    end

    def move_down
      @ed.current_buffer.move_line(1)
    end

    def move_left
      @ed.current_buffer.move_point(-1)
    end

    def move_right
      @ed.current_buffer.move_point(1)
    end

    def change_line
      @ed.current_buffer.change_line
    end

    def delete
      @ed.current_buffer.delete(-1)
    end
  end
end
