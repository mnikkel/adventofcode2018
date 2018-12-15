require 'pry'

class Plants
  attr_reader :current_state
  def initialize(initial_state, patterns)
    @initial_state = '----------' + initial_state + '---------------------------'
    @patterns = make_regexp(patterns)
    @current_state = @initial_state
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
    state = Array.new(@current_state.length, '-')
    @patterns.each do |pattern, plant|
      matches = []
      @current_state.scan(pattern) { matches << Regexp.last_match }
      matches.each { |match| state[match.begin(0) + 2] = plant }
    end
    @current_state = state.join
    # binding.pry
  end

  def generations(gen)
    gen.times { next_generation } 
    @current_state
  end

  def plant_count
    generations(19)
    sum = 0
    @current_state.each_char.with_index do |c, i|
      sum += i - 10 if c == '#'
    end
    sum
  end
end

if __FILE__ == $PROGRAM_NAME
  file = File.open(ARGV[0])
  input = file.readlines.map(&:chomp)
  p = Plants.new(input[0][15..-1], input[2..-1])
  p.next_generation
  puts p.plant_count
end
