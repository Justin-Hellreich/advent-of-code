class Grid
  REGEX = /(\d*),\s(\d*)/

  def initialize
    @points = parse_file
    @width = max(:x)
    @height = max(:y)
    @grid = Array.new(@width+1) do |i|
      Array.new(@height+1) do |j|
        {x: i, y: j, point?: false}
      end
    end
  end

  def largest_finite_area
    map_closest_points
    finite_points = get_finite_points
    finite_points.map do |p|
      @grid.map do |row|
        row.map do |c|
          next 0 if c[:point?] || c[:closest].nil? || !same?(p, c[:closest])
          1
        end.sum
      end.sum
    end.max
  end

  def region_within_1000
    @grid.map { |row| row.map { |c| total_distance(c) < 10000 ? 1 : 0 }.sum }.sum
  end

  private

  def total_distance(c)
    @points.map { |p| distance(p, c) }.sum
  end

  def get_finite_points
    @points.select do |p|
      result = true
      @grid.each.with_index do |row, i|
        row.each.with_index do |c, j|
          next if (!on_border?(i, j) || c[:point?] || c[:closest].nil?)

          # exclude points on the edge
          if same?(p, c[:closest])
            result = false
            break
          end
        end

        break unless result
      end

      result
    end
  end

  def same?(c1, c2)
    c1[:x] == c2[:x] && c1[:y] == c2[:y]
  end

  def on_border?(i, j)
    i == 0 || j == 0 || i == @width || j == @height
  end

  def map_closest_points
    @grid.each do |row|
      row.map do |c|
        return c if c[:point?]

        c[:closest] = closest_point(c)
        c
      end
    end
  end

  def closest_point(c)
    distances = @points.map { |p| distance(p, c) }
    return nil if distances.count(distances.min) > 1
    
    @points.min_by { |p| distance(p, c) }
  end

  def distance(a, b)
    (a[:x] - b[:x]).abs + (a[:y] - b[:y]).abs
  end

  def max(axis)
    @points.max_by { |c| c[axis] }[axis]
  end

  def parse_file
    File.readlines('data.txt').map do |s| 
      x, y = REGEX.match(s)[1..2].map(&:to_i)
      {x: x, y: y, point?: true}
    end
  end
end

puts Grid.new.largest_finite_area
puts Grid.new.region_within_1000
