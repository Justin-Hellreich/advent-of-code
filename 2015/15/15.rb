class Recipe
  # e.g. Butterscotch: capacity -1, durability -2, flavor 6, texture 3, calories 8
  REGEX = /^(\w+)[^-\d]+(-?\d+)[^-\d]+(-?\d+)[^-\d]+(-?\d+)[^-\d]+(-?\d+)[^-\d]+(-?\d+)$/
  MAX = 100.freeze

  def initialize(exact_calories: nil)
    @count = 0
    @ingredients = []
    parse_file
    init_combos(exact_calories)
  end

  def best_cookie?
    @combos.map { |combo| score(combo) }.max
  end

  private

  # confusing formula => confusing algorithm
  # basically multiply ingredients sets by the number
  # of teaspoons, then multiply the resulting
  # ingredient sets elementwise 
  # NOTE: skip the last element in the ingredient list (calories)
  def score(combo)
    @ingredients.map { |arr| arr[0..arr.size-2] } # skip last element
    .map.with_index do |set, i|
      set.map { |val| val * combo[i] } # multiply ingredient values by # of teaspoons
    end.transpose.map { |x| x.reduce(:+) } # multiply elementwise: https://stackoverflow.com/a/2682983/
    .map { |num| [num, 0].max }.reduce(:*) # min of zero, multiply result
  end

  # this will be a big array of all the different
  # combinations of ingredients we can have
  def init_combos(calories)
    @combos = (0..MAX).to_a.combination(@count).to_a # all combinations of x numbers from 1..MAX
      .select { |combo| combo.reduce(:+) == MAX } # the combos which add to 100
      .flat_map { |arr| arr.permutation(@count).to_a } # permute those combos
      .select { |combo| !calories || calories(combo) == calories } # exact calorie count
  end

  # how many calories does this ingredient combo produce?
  def calories(combo)
    combo.map.with_index do |teaspoons, i|
      teaspoons * @ingredients[i][4]
    end.reduce(:+)
  end

   # create ingredients array
  def parse_file
    File.readlines('data.txt').each do |line|
      @count += 1
      @ingredients << REGEX.match(line)[2..7].map(&:to_i)
    end
  end
end

puts "p1: #{Recipe.new.best_cookie?}"
puts "p1: #{Recipe.new(exact_calories: 500).best_cookie?}"
