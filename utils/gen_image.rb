require "chunky_png"
require "csv"
require "fileutils"
require "rumale"

# Creating an image from scratch, save as an interlaced PNG
def draw_image(data, row_number, digit)
  size = 28
  png = ChunkyPNG::Image.new(size, size, ChunkyPNG::Color::WHITE)
  data.each_with_index do |value, index|
    png[index % size, index / size] = ChunkyPNG::Color.rgb(255-value.to_i, 255-value.to_i, 255-value.to_i)
  end
  png.save("images/#{digit}/digit_row_#{row_number}.png", :interlace => true)
end

(0..9).each do |digit|
  some_path = "images/#{digit}/"
  unless File.directory?(some_path)
    FileUtils.mkpath(some_path)
  end
end

x, y = Rumale::Dataset.load_libsvm_file("digits.train.libsvm")

y.to_a.each_with_index do |y, index|
  pixels = x[1,0..783].to_a
  draw_image(pixels, index, y)
end