class Star
  attr_accessor :pos
  attr_reader :vel
  def initialize(pos, vel)
    @pos = pos
    @vel = vel
  end
end

class Sky
  def initialize(pos_and_vel)
    @stars = gen_stars(pos_and_vel)
    @area = area
  end

  def gen_stars(pos_and_vel)
    stars = []
    pos_and_vel.each do |input|
      stars << Star.new(input[0], input[1])
    end
    stars
  end

  def move(reverse = false)
    @stars.each do |star|
      x, y = star.pos
      x_vel = reverse ? -star.vel[0] : star.vel[0]
      y_vel = reverse ? -star.vel[1] : star.vel[1]
      x += x_vel
      y += y_vel
      star.pos = [x, y]
    end
    area
  end

  def find_msg
    seconds = 0
    previous_area = @area + 1
    while previous_area > @area
      seconds += 1
      previous_area = @area
      @area = move
    end
    puts seconds - 1
    move(true)
    draw
  end

  def draw
    min_x = @stars.min_by { |star| star.pos[0] }.pos[0]
    min_y = @stars.min_by { |star| star.pos[1] }.pos[1]
    stars_array = Array.new(range('y') + 1) { Array.new(range('x') + 1, ' ') }
    @stars.each do |star|
      x, y = star.pos
      x -= min_x
      y -= min_y
      stars_array[y][x] = '#'
    end
    stars_array.each { |line| puts line.join }
  end

  def range(x_or_y)
    d = 0 if x_or_y == 'x'
    d = 1 if x_or_y == 'y'
    @stars.max_by { |star| star.pos[d] }.pos[d] - @stars.min_by { |star| star.pos[d] }.pos[d]
  end

  def area
    range('x') * range('y')
  end
end

if __FILE__ == $PROGRAM_NAME
  file = File.open(ARGV[0])
  stars = file.readlines.map(&:chomp)
  pos_and_vel = []
  stars.each do |star|
    s = star.split('> ')
    pos = s[0][10..-1].split(',').map(&:to_i)
    vel = s[1][10..-2].split(',').map(&:to_i)
    pos_and_vel << [pos, vel]
  end
  sky = Sky.new(pos_and_vel)
  sky.find_msg
end
