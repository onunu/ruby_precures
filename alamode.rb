require 'ruby_brain'
require 'rmagick'
require 'pry'

PURECURES = %w(cure_whip cure_custard cure_gelat cure_macron cure_chocolat)
WEIGHT_FILE = 'weights/alamode.yml'

def main(file)
  puts "Reading image '#{file}'"
  img_colors = pickup_colors(file)
  network = RubyBrain::Network.new([10, 6, 5])
  network.init_network
  network.load_weights_from_yaml_file(WEIGHT_FILE)
  purecure = judge(network.get_forward_outputs(img_colors))[0]
  puts "This image is... #{purecure}"
end

def pickup_colors(file)
  img = Magick::ImageList.new(file)
  pixels = img.get_pixels(0, 0, img.columns, img.rows)
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

def judge(outputs)
  PURECURES.zip(outputs).max_by { |output| output.last }
end

main(ARGV[0])
