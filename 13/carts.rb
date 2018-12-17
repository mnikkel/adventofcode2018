require 'pry'

class Cart
  attr_reader :pos, :direction
  DIRECTION = { '^' => :up, '<' => :left, '>' => :right, 'v' => :down }.freeze
  
  def initialize(x, y, direction)
    @pos = [y, x]
    @direction = DIRECTION[direction]
    @choices = %i[left straight right]
    @inc = 2
    @next_direction = @choices[@inc]
  end

  def move(track_piece)
    raise "off the track" if track_piece == '_'
    if track_piece == '+'
      @inc = (@inc + 1) % 3
      @next_direction = @choices[@inc]
      if (@direction == :up || @direction == :down) && @next_direction == :straight
        track_piece = '|'
      elsif (@direction == :left || @direction == :right) && @next_direction == :straight
        track_piece = '-'
      elsif (@direction == :up && @next_direction == :left) || (@direction == :right && @next_direction == :right) || (@direction == :down && @next_direction == :left) || (@direction == :left && @next_direction == :right)
        track_piece = '\\'
      else
        track_piece = '/'
      end
    end
    y, x = @pos
    case track_piece
    when '|'
      @pos = [y + 1, x] if @direction == :down
      @pos = [y - 1, x] if @direction == :up
    when '-'
      @pos = [y, x + 1] if @direction == :right
      @pos = [y, x - 1] if @direction == :left
    when '/'
      if @direction == :left
        @pos = [y + 1, x]
        @direction = :down
      elsif @direction == :up
        @pos = [y, x + 1]
        @direction = :right
      elsif @direction == :right
        @pos = [y - 1, x]
        @direction = :up
      elsif @direction == :down
        @pos = [y, x - 1]
        @direction = :left
      else
        raise "error"
      end
    when '\\'
      if @direction == :right
        @pos = [y + 1, x]
        @direction = :down
      elsif @direction == :up
        @pos = [y, x - 1]
        @direction = :left
      elsif @direction == :left
        @pos = [y - 1, x]
        @direction = :up
      elsif @direction == :down
        @pos = [y, x + 1]
        @direction = :right
      else
        raise "error"
      end
    end
  end
end

class Tracks
  attr_reader :tracks, :carts
  def initialize(track_array)
    @tracks = track_array
    @carts = find_carts
  end

  def pos(yx_array)
    @tracks[yx_array[0]][yx_array[1]]
  end

  def find_carts
    cart_array = []
    @tracks.each_with_index do |line, y|
      line.each_char.with_index do |char, x|
        cart_array << Cart.new(x, y, char) if ['^', '<', '>', 'v'].include?(char)
        @tracks[y][x] = '-' if %w[< >].include?(char)
        @tracks[y][x] = '|' if %w[^ v].include?(char)
      end
    end
    cart_array
  end

  def draw
    translate = { up: '^', down: 'v', left: '<', right: '>' }
    drawable = @tracks.map(&:clone)
    @carts.each do |cart|
      y, x = cart.pos
      drawable[y][x] = translate[cart.direction]
    end
    drawable.each { |line| puts line }
  end

  def move_carts
    collision = false
    until collision
      sorted_carts = sort_carts
      sorted_carts.each do |cart|
        track_piece = pos(cart.pos)
        cart.move(track_piece)
        break if (collision = collision?)
      end
    end
    positions = []
    collisions = []
    @carts.each do |cart|
      if positions.include?(cart.pos)
        collisions << cart.pos
        break
      end
      positions << cart.pos
    end
    y, x = collisions.min
    puts "Collision at: #{x},#{y}"
  end

  def collision?
    positions = @carts.map { |cart| cart.pos }
    positions != positions.uniq
  end

  def sort_carts
    @carts.sort_by { |cart| cart.pos }
  end
end

if __FILE__ == $PROGRAM_NAME
  file = File.open(ARGV[0])
  track_array = file.readlines.map(&:chomp)
  track = Tracks.new(track_array)
  track.move_carts
end
