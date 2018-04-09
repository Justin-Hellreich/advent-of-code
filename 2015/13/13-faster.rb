# mostly a copy of 13.rb, re-write of the find_optimal_arrangement function
# this is an approximation algorithm (from this idea: https://cs.stackexchange.com/a/52753),
# it will NOT give the right answer to the problem, but at least it's polynomial
# (strangely enough, it does find the optimal solution for part b)
# idea: take an arrangement of the table, where x is the number of people,
#       attempt x^2 (all) swaps of people, only accept swaps if they increase 'happiness',
#       repeat this table swap until it no longer increases happiness
class OptimalTable
  REGEX = /(\w+)\swould\s(\w+)\s(\d+).*\s(\w+)/

  def initialize
    @mapping = {}
    @people = []
    parse_file
  end

  def find_optimal_arrangement
    # start with the current arrangement
    arrangement = @people.clone
    current_cost = compute_cost(arrangement)

    # keep swapping arrangements until it no longer increases cost
    new_cost = swap_table
    while new_cost > current_cost
      current_cost = new_cost
      new_cost = swap_table
    end

    new_cost
  end

  def add_person(new_person, happiness: 0)
    @people.each do |person|
      @mapping[mapping_key(new_person, person)] = happiness
      @mapping[mapping_key(person, new_person)] = happiness
    end

    @people << new_person
    self # for chaining
  end

  private

  def mapping_key(person1, person2)
    [person1, person2].join('-')
  end

  def parse_value(gainloss, value)
    value = value.to_i
    gainloss.to_sym == :gain ? value : -value
  end

  def parse_file
    File.readlines('data.txt').each do |line|
      person1, gainloss, value, person2 = REGEX.match(line)[1...5]
      @mapping[mapping_key(person1, person2)] = parse_value(gainloss, value)
      @people += [person1, person2]
    end

    @people.uniq!
  end

  def compute_cost(arrangement)
    pairs = arrangement.each_cons(2).to_a # seating pairs
    pairs << [arrangement[arrangement.size - 1], arrangement[0]] # end and front pair
    pairs.reduce(0) do |sum, pair|
      sum + @mapping[mapping_key(pair[0], pair[1])] + @mapping[mapping_key(pair[1], pair[0])]
    end
  end

  # swap every person with every other person,
  # keep swaps that improve cost
  def swap_table
    current_cost = compute_cost(@people)
    for i in (0..@people.size-1)
      for j in (0..@people.size-1)
        current_cost = swap_if_increases_cost(current_cost, i, j)
      end
    end

    current_cost
  end

  def swap_if_increases_cost(current_cost, i, j)
    swap_people(i, j)
    new_cost = compute_cost(@people)
    if current_cost >= new_cost # didn't help, swap back
      swap_people(j, i)
    else
      current_cost = new_cost
    end

    current_cost
  end

  def swap_people(i, j)
    @people[i], @people[j] = @people[j], @people[i]
  end
end

puts "p1: #{OptimalTable.new.find_optimal_arrangement}"
puts "p2: #{OptimalTable.new.add_person('Justin', happiness: 0).find_optimal_arrangement}"
