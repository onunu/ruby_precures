require 'ruby_brain'
require 'pry'


# ネットワークの構築関数にNetWorkの構造(Array)を渡す
# 2 inputs
# 5 units hidden layer
# 1 output
network_structure = [2, 5, 1]
test_network = RubyBrain::Network.new(network_structure)

# 学習率の設定(学習率が何かはよくわかってない)
test_network.learning_rate = 0.5

# ネットワークの初期化を行う必要があるらしい
test_network.init_network



# 学習用のデータセット
training_dataset = [
  [0, 0],
  [0, 1],
  [1, 0],
  [1, 1]
]

# 教師データ。機械学習っぽくなってきた
training_teacher = [
  [0],
  [0],
  [0],
  [1]
]

# 学習開始, learnメソッドの引数に 学習データ,教師データ, その他パラメータを指定していく
test_network.learn(
  training_dataset, # 学習データ
  training_teacher, # 教師データ
  max_training_count = 3000, # 最大学習回数
  tolerance = 0.0003, # RMSエラー?の許容値。エラーの値がこれより小さくなれば学習十分として終了する
  monitoring_channels=[:best_params_training] # ログ出力設定
)

binding.pry
