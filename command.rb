class Command
  attr_reader :ed, :di

  def initialize(ed, di)
    @ed = ed
    @di = di

    load_keymap
    load_command
  end

  # キーマップの取り込み
  # とりあえずYAML
  # キーコードは環境依存してるかも
  def load_keymap
    keymap  = YAML.load_file('./keymap.yaml')
    keycode = YAML.load_file('./keycode.yaml')
    @keymap = {}
    keycode.each do |key, code|
      next unless keymap.key?(key)
      if code.is_a?(Hash)
        codes = code.flatten
        @keymap[codes[0].to_s] = Hash.new unless @keymap.key?(codes[0].to_s)
        @keymap[codes[0].to_s][codes[1].to_s] = keymap[key]
      else
        @keymap[code.to_s] = keymap[key]
      end
    end
  end

  # コマンドの読み込み
  # commandディレクトリ以下からファイルを再帰読み込み
  # command/plugin以下はプラグインの想定
  # Railsのようにファイル名をsnake_case、クラス（モジュール）をCamelCaseとする前提
  def load_command
    command_path = File.expand_path('../command', __FILE__) + '/'
    plugin_path  = command_path + 'plugin/'
    Dir[command_path + '**/*.rb'].each do |file|
      require file
      length = file.include?('/plugin/') ? plugin_path.length : command_path.length
      names  = file[length, (file.length - length)].split('/')
      klass  = names.inject(Kernel){ |klass, name| klass.const_get(convert_file_to_class(name)) }
      klass.instance_variable_set('@ed', @ed)
      klass.instance_variable_set('@di', @di)
    end
  end

  def convert_file_to_class(path)
    # ファイル名の取得
    tmp = File.basename(path, '.rb')
    # snake case を camel case に変換
    tmp.split('_').map{|s| s.capitalize}.join
  end

  def evaluate(input)
    if @keymap.key?(input)
      if @keymap[input].is_a?(String)
        call(@keymap[input])
      else
        # 矢印キーは複数の入力が渡ってくる
        Keyboard::get_key
        input2 = Keyboard::get_key
        call(@keymap[input][input2]) if @keymap[input].key?(input2)
      end
    else
      @ed.current_buffer.insert_char(input)
    end
  end

  def call(command)
    # とりあえずeval
    # 将来的にはeval以外のアプローチにしたい
    eval(command)
  end
end
