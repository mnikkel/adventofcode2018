class Assemble
  attr_reader :steps, :time
  def initialize(steps)
    @steps = hash_steps(steps)
    @time = hash_time
  end

  def hash_time
    hash_time = {}
    ('A'..'Z').each.with_index { |c, i| hash_time[c] = 61 + i }
    hash_time
  end

  def hash_steps(steps)
    hash_steps = Hash.new { |h, k| h[k] = [] }
    steps.each do |step|
      todo = step[36]
      prior = step[5]
      hash_steps[todo] << prior
    end
    hash_steps
  end

  def next_step
    order = []
    total = (@steps.keys + @steps.values.flatten).uniq.length
    while order.length < total
      next_steps = available_steps(order)
      order << next_steps.min
    end
    order
  end

  def timed_assembly(workers = 5)
    order = []
    working = {}
    seconds = 0
    total = (@steps.keys + @steps.values.flatten).uniq.length
    while order.length < total
      order, working = dec_and_complete(order, working)
      working = add_jobs(working, available_steps(order), workers)
      seconds += 1
    end
    seconds - 1
  end

  def add_jobs(working, next_steps, workers)
    while working.length < workers
      min_step = next_steps.min
      working[min_step] = @time[min_step] unless working.key?(min_step)
      next_steps.delete(min_step)
      break if next_steps.empty?
    end
    working
  end

  def dec_and_complete(order, working)
    working.each do |step, time|
      working[step] = time - 1
      if working[step].zero?
        order << step
        working.delete(step)
      end
    end
    [order, working]
  end

  def available_steps(order)
    available_steps = @steps.select do |_step, required|
      required.all? { |req| order.include?(req) }
    end
    no_prereqs = @steps.values.flatten.uniq.reject { |s| @steps.key?(s) }
    (no_prereqs + available_steps.keys).reject { |step| order.include?(step) }
  end

  def print
    puts next_step.join
  end
end

file = File.open(ARGV[0])
steps = file.readlines.map(&:chomp)
a = Assemble.new(steps)
a.print
p a.timed_assembly
