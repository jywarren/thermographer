require 'rubygems'
require 'RMagick'

f = File.new(ARGV[0], "r")

data = Array.new

max = 0
min = 999

#raw.split('/').each do |col|
while (col = f.gets)
  data_col = Array.new
  col.split(',').each do |cell|
    data_col << cell
    max = cell.to_f if cell.to_f > max
    min = cell.to_f if cell.to_f < min
  end
  data << data_col
end

#puts data
puts data.length.to_s + "," + data[0].length.to_s
img = Magick::Image.new(data.length, data[0].length)

data.each_with_index do |row, row_index|
  row = row.reverse if (row_index/2 == (row_index/2).to_i)
  row.each_with_index do |item, column_index|
    #puts "setting #{row_index}/#{column_index} to #{item}"
    item = 255*((item.to_f - min)/(max - min))
    img.pixel_color(row_index, column_index, "rgb(#{item}, #{item}, #{item})")
  end
end

img.write(ARGV[1])
