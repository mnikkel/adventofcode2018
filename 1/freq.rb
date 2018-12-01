sum = 0
f = File.open("input.txt", "r")
f.readlines.map(&:chomp).each { |num| sum += num.to_i }
puts sum
