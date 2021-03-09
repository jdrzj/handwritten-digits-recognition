# frozen_string_literal: true

require 'chunky_png'
require 'fileutils'
require 'rumale'

# Creating an image from scratch, save as an interlaced PNG
def draw_image(data, row_number, digit)
  size = 28
  png = ChunkyPNG::Image.new(size, size, ChunkyPNG::Color::WHITE)
  data.each_with_index do |value, index|
    png[index % size, index / size] = ChunkyPNG::Color.rgb(255 - value.to_i, 255 - value.to_i, 255 - value.to_i)
  end
  png.save("images/#{digit}/digit_row_#{row_number}.png", interlace: true)
end

puts 'Generating images from 🏭'

(0..9).each do |digit|
  some_path = "images/#{digit}/"
  FileUtils.mkpath(some_path) unless File.directory?(some_path)
end

x, y = Rumale::Dataset.load_libsvm_file('mnist.t')
count = y.size

y.to_a.each_with_index do |label, index|
  puts "Generating image #{index + 1}/#{count}" if index.zero? || index % 1000 == 999
  pixels = x[1, 0..783].to_a
  draw_image(pixels, index, label)
end
