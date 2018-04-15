class Grid
  def initialize(corners_on = false)
    @corners_on = corners_on
    parse_file
  end

  def simulate(steps, debug = false)
    steps.times { print if debug; simulate_step }
    self # for chaining
  end

  def lights_on
    @grid.map { |line| line.reduce(:+) }.reduce(:+)
  end

  private

  CHAR_MAP = {
    '.': 0,
    '#': 1
  }.freeze

  def simulate_step
    @new_grid = @grid.map { |line| line.clone } # deep-ish clone

    for i in (0..@length - 1)
      for j in (0..@length - 1)
        count = neighbours_on(i, j)
        toggle(i, j) if (count < 2 || count > 3) && @grid[i][j] == 1
        toggle(i, j) if count == 3 && @grid[i][j] == 0
      end
    end

    @grid = @new_grid
  end

  def toggle(i, j)
    return if @corners_on && corner?(i, j)
    @new_grid[i][j] = @new_grid[i][j] == 1 ? 0 : 1
  end

  def neighbours_on(i, j)
    neighbours = []

    for t in (i-1..i+1)
      for r in (j-1..j+1)
        next if [t, r] == [i, j] || t < 0 || t >= @length || r < 0 || r >= @length
        neighbours << @grid[t][r]
      end
    end

    neighbours.reduce(:+)
  end

  def corner?(i, j)
    (i == 0 && j == 0) || (i == 0 && j == @length - 1) || (j == 0 && i == @length - 1) || (i == @length - 1 && j == @length - 1)
  end

  def parse_file
    lines = File.readlines('data.txt')
    @length = lines.size

    @grid = lines.map.with_index do |line, i|
      line.strip.chars.map.with_index do |char, j|
        @corners_on && corner?(i, j) ? 1 : CHAR_MAP[char.to_sym]
      end
    end
  end

  def print
    @grid.each do |line|
      puts line.map { |val| val == 1 ? '#' : '.' }.join
    end
    puts ""
  end
end

puts "p1: #{Grid.new.simulate(100).lights_on}"
puts "p2: #{Grid.new(corners_on: true).simulate(100).lights_on}"
