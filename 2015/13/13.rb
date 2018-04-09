class OptimalTable
  # e.g. Alice would lose 57 happiness units by sitting next to Bob.
  REGEX = /(\w+)\swould\s(\w+)\s(\d+).*\s(\w+)/

  def initialize
    @mapping = {}
    @people = []
    parse_file
  end

  # brute force: generate all permutations, take max
  def find_optimal_arrangement
    @people.permutation(@people.size).map { |arrangement| compute_cost(arrangement) }.max
  end

  # add a new person, use the same happiness value for everyone
  def add_person(new_person, happiness: 0)
    @people.each do |person|
      @mapping[mapping_key(new_person, person)] = happiness
      @mapping[mapping_key(person, new_person)] = happiness
    end

    @people << new_person
    self # for chaining
  end

  private

  # key to mapping hash
  def mapping_key(person1, person2)
    [person1, person2].join('-')
  end

  def parse_value(gainloss, value)
    value = value.to_i
    gainloss.to_sym == :gain ? value : -value
  end

  def parse_file
    # mapping will look like { 'person1-person2': value }
    File.readlines('data.txt').each do |line|
      person1, gainloss, value, person2 = REGEX.match(line)[1...5]
      @mapping[mapping_key(person1, person2)] = parse_value(gainloss, value)
      @people += [person1, person2]
    end

    @people.uniq!
  end

  # compute the cost (happiness) of a given arrangement
  def compute_cost(arrangement)
    pairs = arrangement.each_cons(2).to_a # seating pairs
    pairs << [arrangement[arrangement.size - 1], arrangement[0]] # end and front pair
    pairs.reduce(0) do |sum, pair|
      sum + @mapping[mapping_key(pair[0], pair[1])] + @mapping[mapping_key(pair[1], pair[0])]
    end
  end
end

puts "p1: #{OptimalTable.new.find_optimal_arrangement}"
puts "p2: #{OptimalTable.new.add_person('Justin', happiness: 0).find_optimal_arrangement}"
