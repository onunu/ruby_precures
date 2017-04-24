require 'ruby_brain'
require 'rmagick'
require 'pry'

def main
  # 学習用のデータセット
  # 明示的に初期化
  training_dataset = []
  training_teacher = []

  Dir.glob('./img/*') do |file|
    puts "Read...#{file}"
    # Rmagickで画像を読み込み
    img = Magick::ImageList.new(file)
    pixels = img.get_pixels(0, 0, img.columns, img.rows)
    training_dataset << pickup_colors(pixels)
    training_teacher << [ img.filename.match(/(whip|custard|gelato|macron|chocolat)/)[0] ]
  end

  training_teacher.map! do |data|
    case data
    when ['whip'] then
      [1, 0, 0, 0, 0]
    when ['custard'] then
      [0, 1, 0, 0, 0]
    when ['gelato'] then
      [0, 0, 1, 0, 0]
    when ['macron'] then
      [1, 0, 0, 1, 0]
    else [4]
      [0, 0, 0, 0, 1]
    end
  end

  # ネットワーク構成
  network = RubyBrain::Network.new([10, 6, 5])

  # 学習率の設定
  network.learning_rate = 0.6

  # ネットワークの初期化
  network.init_network

  # 学習させる
  network.learn(
    training_dataset, # 学習データ
    training_teacher, # 教師データ
    max_training_count = 3000, # 最大学習回数
    tolerance = 0.0003, # RMSエラー?の許容値。エラーの値がこれより小さくなれば学習十分として終了する
    monitoring_channels=[:best_params_training] # ログ出力設定
  )

  network.dump_weights_to_yaml('./weights/alamode.yml')
end


# pixelから画像の特徴色を抜き出して配列にするメソッド
def kirakira(file)
  img = Magick::ImageList.new(file)
  pixels = img.get_pixels(0, 0, img.columns, img.rows)
  pickup_colors(pixels)
end

def pickup_colors(pixels)
  colors = {}
  pixels.each do |pixel|
    colors[pixel.to_color.to_s] ||= 0
    colors[pixel.to_color.to_s] += 1
  end
  picked = colors.sort_by{ |k, v| v }.reverse[0..9].map{ |c| c[0] }
  picked.map do |color|
    color[1..-1].hex
  end
end
  

main
puts 'Network end learning'
