# frozen_string_literal: true

require "csv"
require "pry"

filename = ARGV[0]

if filename.nil?
  puts "You need to specify filename"
  exit(1)
elsif !File.exist?(filename)
  puts "File #{filename} does not exist"
  exit(1)
end
puts "Converting: #{filename} 📑"
file_line_count = File.readlines(filename).count
file = CSV.open(filename, col_sep: "\s")
data = file.map.with_index do |line, line_index|
  puts "Converting line #{line_index + 1}/#{file_line_count}" if line_index.zero? || line_index % 1000 == 999
  # Create new array with zeros
  new_line = Array.new(784, "0")
  label = line.first
  line[1..-1].map { |a| a.split(":") }.each do |tuple|
    value_index, value = tuple
    # Write to array of zeros value at value_index
    new_line[value_index.to_i - 1] = value
  end
  new_line = new_line.map.with_index do |value, index|
    # Convert to libsvm data format: 0:0, 0:1
    "#{index + 1}:#{value}"
  end
  # Add label as first element
  "#{label} #{new_line.join(" ")}"
end.join("\n")

File.write(filename, data)
puts "Finished 🏁"
