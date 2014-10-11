module Rows
  module BufferCommand
    class << self
      def delete_line
        @ed.current_buffer.delete_line
      end
    end
  end
end
