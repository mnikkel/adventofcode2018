file = File.open(ARGV[0])
events = file.readlines.map(&:chomp)
events_hash = {}
events.each do |event|
  te = event.split("]")
  time = Time.new(te[0][1..4], te[0][6..7], te[0][9..10], te[0][12..13], te[0][15..16])
  events_hash[time] = te[1][1..-1]
end

# sleep_time = Hash.new { |h, k| h[k] = [] }
sleep_time = Hash.new(0)
guard = 0
asleep = nil
events_hash.keys.sort.each do |event|
  if g = events_hash[event].match('\d+')
    guard = g.to_s.to_i
  elsif asleep
    sleep_time[guard] += event - asleep
    asleep = nil
  else
    asleep = event
  end
end

most_asleep = sleep_time.key(sleep_time.values.max)

sleep_minutes = Hash.new(0)
minute = nil
sleepy_guard = false

events_hash.keys.sort.each do |event|
  if g = events_hash[event].match(most_asleep.to_s)
    sleepy_guard = true
  elsif g = events_hash[event].match('\d+')
    sleepy_guard = false
  elsif minute
    (minute...event.min).each { |m| sleep_minutes[m] += 1 }
    minute = nil
  elsif sleepy_guard
    minute = event.min
  end
end

asleep_minute = sleep_minutes.key(sleep_minutes.values.max)

puts most_asleep * asleep_minute

all_minutes = Hash.new { |h, k| h[k] = Hash.new(0) }

events_hash.keys.sort.each do |event|
  if g = events_hash[event].match('\d+')
    guard = g.to_s.to_i
  elsif asleep
    (minute...event.min).each { |m| all_minutes[guard][m] += 1 }
    asleep = false
  else
    minute = event.min
    asleep = true
  end
end

most_minutes = {}
all_minutes.each do |g, m|
  most_minutes[g] = m.values.max
end

guard_most = most_minutes.key(most_minutes.values.max)
puts guard_most
minutes_most = all_minutes[guard_most].key(most_minutes[guard_most])
puts guard_most * minutes_most
