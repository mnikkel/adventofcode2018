GRID_SERIAL_NUMBER = 9435

class Cell
  attr_reader :power, :pos
  def initialize(x, y)
    @x = x
    @y = y
    @pos = [x, y]
    @rack_ID = x + 10
    @power = set_power
  end

  def set_power
    p = (@rack_ID * @y) + GRID_SERIAL_NUMBER
    p *= @rack_ID
    p = (p % 1000) / 100 # Keep only the hundreds digit
    @power = p - 5
  end
end

class Grid
  attr_reader :grid
  def initialize
    @grid = gen_grid
    # @most_power = most_power
  end

  def gen_grid
    g = Array.new(300) { Array.new }
    (1..300).each do |y|
      (1..300).each do |x|
        g[y - 1] << Cell.new(x, y)
      end
    end
    @grid = g
  end

  def most_power
    power_hash = {}
    (0..299).each do |y|
      (0..299).each do |x|
        p = square_power(x, y)
        power_hash[p[1]] = [p[0], @grid[y][x].pos]
      end
    end
    power_hash.max[1]
  end

  def square_power(x, y)
    p = [1, @grid[y][x].power]
    max = [(299 - x), (299 - y)].min
    last = p[1]
    (1..max).each do |i|
      sum = 0
      (0..i).each do |j|
        sum += @grid[y + i][x + j].power
        sum += @grid[y + j][x + i].power
      end
      sum -= @grid[y + i][x + i].power
      sum += last
      p = [i + 1, sum] if sum > p[1]
      last = sum
    end
    p
  end
end

if __FILE__ == $PROGRAM_NAME
  c = Grid.new
  puts c.most_power
end
