class Point
  attr_reader :x, :y, :steps

  def initialize(x, y, steps)
    @x = x
    @y = y
    @steps = steps
  end

  def next_path(move)
    dir = move[0]
    dist = move[1..move.size-1].to_i

    (1..dist).map { |d| Point.new(@x + x_mult(dir) * d, @y + y_mult(dir) * d, @steps + d) }
  end

  def to_a
    [@x, @y]
  end

  private

  def x_mult(dir)
    return 1 if dir == 'R'
    return -1 if dir == 'L'
    0
  end

  def y_mult(dir)
    return 1 if dir == 'U'
    return -1 if dir == 'D'
    0
  end
end

class Wire
  def initialize(path)
    @path = path
    @loc = Point.new(0, 0, 0)
  end

  def walk
    @walk ||= @path.map do |move|
      next_path = @loc.next_path(move)
      @loc = next_path[next_path.size-1]
      next_path
    end.flatten
  end
end

class System
  def initialize
    wire_paths = parse_file
    @wire1 = Wire.new wire_paths[0]
    @wire2 = Wire.new wire_paths[1]
  end

  private

  def intersections
    @intersections ||= @wire1.walk.map(&:to_a) & @wire2.walk.map(&:to_a)
  end

  def parse_file
    File.readlines('data.txt').map { |l| l.split(',') }
  end
end

class ManhattenSystem < System
  def closest_intersection_distance
    intersections.map { |point| manhatten_distance(point) }.min
  end

  private

  def manhatten_distance(point) # from (0, 0)
    point[0].abs + point[1].abs
  end
end

class StepsSystem < System
  def closest_intersection_distance
    intersections.map { |point| steps_distance(point) }.min
  end

  private

  def steps_distance(point)
    find_point_in_walk(point, @wire1.walk).steps + find_point_in_walk(point, @wire2.walk).steps
  end

  def find_point_in_walk(point, walk)
    walk.find { |_p| _p.x == point[0] && _p.y == point[1] }
  end

end

puts ManhattenSystem.new.closest_intersection_distance
puts StepsSystem.new.closest_intersection_distance

