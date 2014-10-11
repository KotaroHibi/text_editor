class Screen
  attr_reader :rows, :cols, :attributes
  def initialize
    # 画面の物理情報をセットする
    @rows = 100
    @cols = 80
    @attributes = {}
    true
  end

  def finish
    true
  end
end
