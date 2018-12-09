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
      (0..x).each do |col|
        grid[row] << '.'
      end
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
      max = @coords.sort_by { |coord| coord[c]}.last
      x = max[c] if c == 0
      y = max[c] if c == 1
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
      row.each_with_index do |col, x|
        @coords.each do |coord|
          dist_hash[[x, y]] << (coord[0] - x).abs + (coord[1] - y).abs
        end
      end
    end
    dist_hash
  end
  
  def closest
    all_distances = self.distance
    closest_distance = Hash.new { |h, k| h[k] = [] }
    all_distances.each do |point, dist|
      min = dist.min
      closest_distance[dist.index(min)] << point if dist.count(min) == 1
    end
    closest_distance
  end

  def area
    closest_coord = self.closest
    edge_x, edge_y = self.max_xy
    finite = closest_coord.select do |coord, points|
      points.all? { |point| (1...edge_x).include?(point[0]) &&
                            (1...edge_y).include?(point[1]) }
    end
    finite
  end
  
  def largest_area
    self.area.sort_by { |k, v| v.length }.last[1].length
  end
end

file = File.open(ARGV[0])
str_coords = file.readlines.map(&:chomp)
coords = []
str_coords.each do |str|
  x, y = str.split(",")
  coords << [x.to_i, y.to_i]
end
g = Grid.new(coords)
puts "Largest Area: #{g.largest_area}"