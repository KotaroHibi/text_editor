class Keyboard
  class << self
    def get_key
      input = CursesAPI::getch
      input = input.to_s unless input.nil?
      input
    end
  end
end
