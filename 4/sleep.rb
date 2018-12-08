file = File.open(ARGV[0])
events = file.readlines.map(&:chomp)
events_hash = {}
events.each do |event|
  te = event.split("]")
  time = Time.new(te[0][1..4], te[0][6..7], te[0][9..10], te[0][12..13], te[0][15..16])
  events_hash[time] = te[1][1..-1]
end

sleep_time = Hash.new { |h, k| h[k] = [] }
guard = 0
events_hash.keys.sort.each do |event|
  if g = events_hash[event].match('\d+')
    guard = g.to_s.to_i
  else
    sleep_time[guard] << event
  end
end
