class Grid
  attr_reader :coords
  def initialize(coords)
    @coords = coords
    @grid = gen_grid
  end

  def gen_grid
    x, y = max_xy
    grid = []
    (0..y).each do |row|
      grid << []
      (x + 1).times { grid[row] << '.' }
    end
    add_points(grid)
  end

  def add_points(empty_grid)
    @coords.each do |coord|
      x, y = coord
      empty_grid[y][x] = '#'
    end
    empty_grid
  end

  def max_xy
    x, y = nil
    [0, 1].each do |c|
      max = @coords.max_by { |coord| coord[c] }
      c.zero? ? x = max[c] : y = max[c]
    end
    [x, y]
  end

  def draw
    @grid.each do |row|
      puts row.join
    end
  end

  def distance
    dist_hash = Hash.new { |h, k| h[k] = [] }
    @grid.each_with_index do |row, y|
      row.length.times do |x|
        @coords.each do |coord|
          dist_hash[[x, y]] << (coord[0] - x).abs + (coord[1] - y).abs
        end
      end
    end
    dist_hash
  end

  def closest
    all_distances = distance
    closest_distance = Hash.new { |h, k| h[k] = [] }
    all_distances.each do |point, dist|
      min = dist.min
      closest_distance[dist.index(min)] << point if dist.count(min) == 1
    end
    closest_distance
  end

  def area
    closest_coord = closest
    edge_x, edge_y = max_xy
    finite = closest_coord.select do |_coord, points|
      points.all? do |point|
        x_ok = (1...edge_x).cover?(point[0])
        y_ok = (1...edge_y).cover?(point[1])
        x_ok && y_ok
      end
    end
    finite
  end

  def largest_area
    area.max_by { |_k, v| v.length }[1].length
  end

  def close_enough(max_dist = 10_000)
    total_distance = []
    distance.each do |point, distances|
      total_distance << point if distances.sum < max_dist
    end
    total_distance.length
  end
end

file = File.open(ARGV[0])
str_coords = file.readlines.map(&:chomp)
coords = []
str_coords.each do |str|
  x, y = str.split(',')
  coords << [x.to_i, y.to_i]
end
g = Grid.new(coords)
puts "Largest Area: #{g.largest_area}"
puts "Close enough: #{g.close_enough}"
