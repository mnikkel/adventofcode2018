require 'pry'

class Plants
  attr_reader :current_state
  def initialize(initial_state, patterns)
    @initial_state = initial_state
    @patterns = make_regexp(patterns)
    @current_state = @initial_state
    @pot0 = 0
    @plants_sum = 0
    @diff = 0
    @same_diff = 0
    @iterations = 0
    @generations = 0
  end

  def make_regexp(patterns)
    p_hash = {}
    patterns.each do |pattern|
      r = Regexp.new(/(?=#{pattern[0..4]})/)
      p_hash[r] = pattern[-1]
    end
    p_hash
  end

  def next_generation
    @iterations += 1
    prev_plant_count = plant_count
    pad
    state = Array.new(@current_state.length, '-')
    @patterns.each do |pattern, plant|
      matches = []
      @current_state.scan(pattern) { matches << Regexp.last_match }
      matches.each { |match| state[match.begin(0) + 2] = plant }
    end
    @current_state = state.join
    diff(prev_plant_count)
    # binding.pry
  end

  def diff(prev_plant_count)
    new_diff = plant_count - prev_plant_count
    if new_diff == @diff
      @same_diff += 1
    else
      @diff = new_diff
      @same_diff = 0
    end

  end

  def pad
    if @current_state.index('#') < 5
      @current_state = '-----' + @current_state
      @pot0 += 5
    end

    if @current_state.length - @current_state.rindex('#') < 5
      @current_state += '-----'
    end
  end

  def generations(gen)
    @generations = gen
    gen.times do
      next_generation
      if @same_diff == 100
        puts plant_count + (@generations - @iterations) * @diff
        return
      end
    end
    puts plant_count if @same_diff != 100
  end

  def plant_count
    sum = 0
    @current_state.each_char.with_index do |c, i|
      sum += i - @pot0 if c == '#'
    end
    sum
  end
end

if __FILE__ == $PROGRAM_NAME
  file = File.open(ARGV[0])
  input = file.readlines.map(&:chomp)
  p = Plants.new(input[0][15..-1], input[2..-1])
  puts '20 Generations:'
  p.generations(20)
  puts '50 Billion Generations:'
  p.generations(50_000_000_000)
end
