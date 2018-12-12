class Marbles
  def initialize(players, high_marble)
    @high_marble = high_marble
    @players = Array.new(players, 0)
    @circle = [0]
    @current = 0
    @player = 0
  end

  def play
    (1..@high_marble).each do |marble|
      @players.rotate!
      if (marble % 23).zero?
        @players[0] += marble
        @circle.rotate!(-7)
        @players[0] += @circle.shift
      else
        @circle.rotate!(2)
        @circle.unshift(marble)
      end
    end
    @players.max
  end

  def play2
    c = Cll.new(Node.new(0))
    (1..@high_marble).each do |value|
      node = Node.new(value)
      @player = (@player + 1) % @players.length
      if (value % 23).zero?
        @players[@player] += value
        c.rotate(-7)
        @players[@player] += c.current.value
        c.delete
      else
        c.rotate
        c.insert(node)
      end
    end
    @players.max
  end
end

class Node
  attr_accessor :prev_marble, :next_marble
  attr_reader :value

  def initialize(value)
    @prev_marble = nil
    @next_marble = nil
    @value = value
  end
end

class Cll
  attr_reader :current
  def initialize(node)
    @current = node
    node.prev_marble = node
    node.next_marble = node
  end

  def insert(node)
    node.next_marble = @current.next_marble
    node.prev_marble = @current
    @current.next_marble.prev_marble = node
    @current.next_marble = node
    @current = node
  end

  def delete
    @current.prev_marble.next_marble = @current.next_marble
    @current.next_marble.prev_marble = @current.prev_marble
    @current = @current.next_marble
  end

  def rotate(count = 1)
    if count > 0
      count.times { @current = @current.next_marble }
    else
      count.abs.times { @current = @current.prev_marble }
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  g = Marbles.new(416, 71_617)
  puts g.play2
  g2 = Marbles.new(416, 7_161_700)
  puts g2.play2
end
