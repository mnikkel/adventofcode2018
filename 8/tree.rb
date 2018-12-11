class Tree
  def initialize(license)
    @license = license
    @nodes = add_node
  end

  def add_node(parent = nil)
    child_count, meta_count = @license.shift(2)
    n = Node.new(child_count, meta_count)
    child_count.times { add_node(n) }
    n.metadata = @license.shift(n.meta_count)
    if parent
      parent.child_nodes << n
    else
      @nodes = n
    end
  end

  def sum(node = @nodes)
    parent_sum = node.metadata.sum
    children_sum = 0
    node.child_nodes.each do |n|
      children_sum += sum(n)
    end
    parent_sum + children_sum
  end

  def sum2(node = @nodes)
    if node.child_nodes.length.zero?
      total = node.metadata.sum
    else
      total = 0
      node.metadata.each do |i|
        i -= 1
        if i < node.child_count
          total += sum2(node.child_nodes[i])
        end
      end
    end
    total
  end
end

class Node
  attr_accessor :child_nodes, :metadata
  attr_reader :meta_count, :child_count
  def initialize(child_count, meta_count)
    @child_count = child_count
    @meta_count = meta_count
    @child_nodes = []
    @metadata = []
  end
end

if __FILE__ == $PROGRAM_NAME
  file = File.open(ARGV[0])
  license = file.gets.chomp.split.map(&:to_i)
  t = Tree.new(license)
  puts t.sum
  puts t.sum2
end
