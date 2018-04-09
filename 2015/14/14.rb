class Reindeer
  attr_accessor :points, :distance

  def initialize(name, speed, fly_time, rest_time)
    @name = name
    @speed = speed.to_i
    @fly_time = fly_time.to_i
    @rest_time = rest_time.to_i

    @distance = 0
    @cur_fly_time = 0
    @cur_rest_time = 0
    @resting = false
    @points = 0
  end

  # simulate flying for the given time
  # this will not carry over flying/resting time
  def simulate(time)
    while time > 0
      fly_time = [@fly_time, time].min
      @distance += @speed * fly_time
      time -= fly_time
      time -= @rest_time # might go under 0, doesn't matter
    end

    @distance
  end

  # simulate flying just one second,
  # will carry over flying/resting time
  def sim_one_second
    # if resting, check if should stop
    if @resting
      @cur_rest_time += 1
      return if @cur_rest_time <= @rest_time # continue resting
      @resting = false
      @cur_rest_time = 0
    end

    @cur_fly_time += 1

    # flew for long enough, start resting
    if @cur_fly_time > @fly_time
      rest(1)
      return @distance
    end

    simulate(1)
  end

  private

  def rest(time)
    @resting = true
    @cur_fly_time = 0
    @cur_rest_time += time
  end
end

class ReindeerSim
  REGEX = /^(\w+)[^\d]+(\d+)[^\d]+(\d+)[^\d]+(\d+).+$/.freeze
  RUN_TIME = 2503.freeze

  def initialize
    @reindeer = []
    parse_file
  end

  # simulate full race, return max distance
  def sim
    @reindeer.map { |r| r.simulate(RUN_TIME) }.max
  end

  # simulate a lot of one second races
  def race
    RUN_TIME.times do
      @reindeer.map { |r| r.sim_one_second }
      winning?.each { |r| r.points += 1 }
    end

    @reindeer.max_by(&:points).points
  end

  private

  # winner by distance
  def winning?
    @reindeer.group_by(&:distance).max.last # get all winners
  end

  def parse_file
    File.readlines('data.txt').each do |line|
      @reindeer << Reindeer.new(*REGEX.match(line)[1..5])
    end
  end
end

puts "p1: #{ReindeerSim.new.sim}"
puts "p2: #{ReindeerSim.new.race}"
