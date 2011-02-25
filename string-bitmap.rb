require 'rubygems'
require 'RMagick'

f = File.new(ARGV[0], "r")

data = Array.new

max = 0
min = 999

while (col = f.gets)
  data_col = Array.new
  if col[0] != 60 # if it's not the line number <#>
    # check for trailing comma, remove it:
    col = col[0..-4] if col[-3] == 44
    col.split(',').each do |cell|
      data_col << cell
      max = cell.to_f if cell.to_f > max
      min = cell.to_f if cell.to_f < min
    end
    data << data_col
  end
end

#puts data
puts data.length.to_s + "," + data[0].length.to_s
img = Magick::Image.new(data.length, data[0].length)

data.reverse.each_with_index do |row, row_index|
  row = row.reverse unless row_index.odd?
  row.each_with_index do |item, column_index|
    #puts "setting #{row_index}/#{column_index} to #{item}"
    item = 255*((item.to_f - min)/(max - min))
    img.pixel_color(row_index, column_index, "rgb(#{item}, #{item}, #{item})")
  end
end

img.write(ARGV[1])
