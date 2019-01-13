class Unit
  def initialize(pos, type)
    @pos = pos
    @type = type
    @health = 200
    @enemy = type == 'E' ? 'G' : 'E'
  end
end

class Battlefield
  attr_reader :map
  def initialize(map)
    @map = map
  end

  def graph
    nodes = []
    @map.each do |row|
      row.each do |tile|
        if tile != "#"
          nodes << Node.new
        end
      end
    end
  end
end

class Combat
  def initialize(battlefield)
    @battlefield = battlefield
    @round = 0
    @unit_order
  end

  def start
    until combat_over?
      @round += 1
      turn_order
      @unit_order.each { |unit| take_turn(unit) }
    end

    puts @round * hp_left
  end

  def take_turn(unit)
    return if combat_over?

    move(unit)
    attack(unit)
  end

  def move(unit)
    in_range = find_in_range(unit.enemy)
    return if in_range.empty?



class BreadthFirstSearch
  def initialize(graph, source_node)
    @graph = graph
    @source_node = source_node
  end
end

if __FILE__ == $PROGRAM_NAME
  file = File.open(ARGV[0])
  map = file.readlines.map(&:chomp)
  map_array = []
  map.each { |row| map_array << row.split("") }
  b = Battlefield.new(map_array)
end
