input = ARGV[0]
file = File.open(input)
boxes = file.readlines.map(&:chomp)
two = 0
three = 0
boxes.each do |box|
  count = Hash.new(0)
  box.each_char { |c| count[c] += 1 }
  two += 1 if count.value?(2)
  three += 1 if count.value?(3)
end
puts two * three
