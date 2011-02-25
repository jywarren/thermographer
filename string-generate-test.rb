require 'rubygems'
require 'RMagick'

f = File.new(ARGV[0], "r")

data = Array.new

max = 0
min = 999

120.times do
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