class AuntFinder
  REGEX = /(?:(\w+):\s(\d+),*[\s]*)/.freeze

  def initialize(conditions = {})
    @conditions = conditions
    @mystery_aunt = File.readlines('mystery-sue.txt').map(&:strip).join(', ').scan(REGEX).to_h
    @all_aunts = File.readlines('data.txt').map do |line|
      line.scan(REGEX).to_h
    end
  end

  def solve
    @all_aunts.index { |aunt| alike?(aunt) } + 1 # aunts are 1 based
  end

  private

  def alike?(aunt)
    @conditions.each do |key, function|
      key = key.to_s
      next unless aunt[key]
      return false unless aunt[key].send(function, @mystery_aunt[key])
      aunt.delete(key)
    end

    (aunt.to_a - @mystery_aunt.to_a).empty?
  end
end

puts "p1: #{AuntFinder.new.solve}"
puts "p2: #{AuntFinder.new({ cats: :>, trees: :>, pomeranians: :<, goldfish: :< }).solve}"
