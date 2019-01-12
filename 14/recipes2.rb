class Recipes
  def initialize(target)
    @target = target
    @recipes = [3, 7]
    @a = 0
    @b = 1
  end

  def new_score
    @recipes[@a] + @recipes[@b]
  end

  def new_recipes
    #@recipes += new_score
    add_score = @recipes[@a] + @recipes[@b]
    if add_score < 10
      @recipes << add_score
    else
      @recipes << 1
      @recipes << add_score - 10
    end
    a_steps = @recipes[@a] + 1
    b_steps = @recipes[@b] + 1
    @a = (@a + a_steps) % @recipes.length
    @b = (@b + b_steps) % @recipes.length
  end

  def find_after
    while @recipes.length < (@target + 10)
      new_recipes
    end
    puts @recipes[@target..@target + 10].join
  end

  def find_seq
    1_000_000.times { new_recipes }
    until (match = match_found?)
      1_000_000.times { new_recipes }
    end
    puts match
  end

  def match_found?
    @recipes.map(&:to_s).join.index(@target.to_s)
  end
end

r = Recipes.new(157901)
r.find_after
r.find_seq
