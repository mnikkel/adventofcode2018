sum = 0
results = {0=>true}
f = File.open("input.txt", "r")
inputs = f.readlines.map(&:chomp).map(&:to_i)
dup = false
while dup == false
  inputs.each do |num| 
    sum += num
    if results.has_key?(sum)
      puts sum
      dup = true
      break
    else
      results[sum] = true
    end
  end
end
