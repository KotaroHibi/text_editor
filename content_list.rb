require './content'
class ContentList < Content
  def initialize(content = '')
    if content.is_a?(Array)
      @content = content
    else
      @content = [content]
    end
  end
end
