class Coord
  attr_accessor :x, :y

  def initialize(x, y, dx, dy)
    @x = x
    @y = y
    @dx = dx
    @dy = dy
  end

  def move
    @x += @dx
    @y += @dy
    self
  end

  def debug
    puts "#{@x} #{@y} #{@dx} #{@dy}"
  end
end

class Sky
  def initialize
    @coords_array = parse_file
    @coords_hash = coords_array_to_hash @coords_array
    @seconds = 0
  end

  def run
    while !small_boundaries?
      move
    end

    loop do
      show
      move
      sleep 2
    end
  end

  private

  def small_boundaries?
    px, py, nx, ny = mk_boundaries
    px - nx < 100 && py - ny < 100
  end

  def show
    puts "Second: #{@seconds}"

    px, py, nx, ny = mk_boundaries
    (ny..py).each do |j|
      (nx..px).each do |i|
        print @coords_hash.key?(mk_key(i, j)) ? "#" : "."
      end
      puts ""
    end
    puts ""
  end

  def move
    @coords_hash = coords_array_to_hash @coords_array.map(&:move)
    @seconds += 1
  end

  def mk_boundaries
    [
      @coords_array.max_by { |c| c.x }.x,
      @coords_array.max_by { |c| c.y }.y,
      @coords_array.min_by { |c| c.x }.x,
      @coords_array.min_by { |c| c.y }.y
    ]
  end

  def coords_array_to_hash(array)
    coords = {}
    array.each do |coord|
      coords[mk_key(coord.x, coord.y)] = coord
    end
    coords
  end

  def mk_key(x, y)
    "#{x}-#{y}"
  end

  def parse_file
    File.readlines('data.txt').map do |line|
      x, y, dx, dy = line.split("=")[1..2].map do |coord|
        coord.gsub(/[<>,]/, "").split(" ")[0..1].map(&:to_i)
      end.flatten
      Coord.new x, y, dx, dy
    end
  end
end

Sky.new.run
