class Polymers
  attr_reader :polymer
  def initialize(polymer)
    @polymer = polymer
  end

  def shrink
    shrunk = true
    while shrunk == true
      @polymer.each_char.with_index do |c, i|
         if i + 1 == @polymer.length
         shrunk = false
         elsif c.casecmp(@polymer[i + 1]).zero? && c != @polymer[i + 1]
          @polymer = @polymer[0...i] + @polymer[i + 2..-1]
          break
        end
      end
    end
  end
end

file = File.open(ARGV[0])
p = Polymers.new(file.gets.chomp)
# p = Polymers.new("cCaegGEBc")
p.shrink
puts p.polymer.length