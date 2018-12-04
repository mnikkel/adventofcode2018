file = File.open(ARGV[0])

claims = []
file.readlines.each do |line|
  split = line.split
  claims << [split[2], split[3]]
end

claim_hash = Hash.new(0)

claims.each do |claim|
  x_off, y_off = claim[0].split(",").map(&:to_i)
  x, y = claim[1].split("x").map(&:to_i)
  (1..y).each do |i|
    (1..x).each do |j|
      claim_hash[[x_off+j, y_off+i]] += 1
    end
  end
end

puts claim_hash.values.select { |v| v > 1 }.length
