class PathFinder
  REGEX = /^(\w+)\sto\s(\w+)\s=\s(\w+)$/ # e.g. AlphaCentauri to Snowdin = 66

  def initialize
    @distances = {}
    @cities = []
    parse_file
  end

  # generate permutation of cities, map them to distances, run
  # function :type on the result
  # (the input only has seven cities -> brute force is fine)
  def find_distance(type: :min)
    distance = @cities.permutation(@cities.size).map do |path|
      path.each_cons(2).reduce(0) do |sum, pair|
        sum + @distances[distance_key(pair[0], pair[1])]
      end
    end.send(type)
  end

  private

  # create @distances hash and @cities array
  def parse_file
    File.readlines('data.txt').each do |line|
      from, to, dist = REGEX.match(line)[1..4]
      @distances[distance_key(from, to)] = dist.to_i
      @cities += [from.to_sym, to.to_sym]
    end

    @cities.uniq!
  end

  # key for the @distance hash
  # alphabatize the cities so we don't need duplicate mappings
  # e.g. b -> a and a -> b just needs a -> b
  def distance_key(from, to)
    "#{[from, to].min}-#{[from, to].max}".to_sym
  end
end

puts "p1: #{PathFinder.new.find_distance(type: :min)}"
puts "p2: #{PathFinder.new.find_distance(type: :max)}"
