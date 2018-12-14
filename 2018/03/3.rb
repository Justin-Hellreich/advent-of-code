class Claim
  attr_reader :id, :x1, :y1, :x2, :y2, :width, :height

  def initialize(id, x, y, width, height)
    @id = id
    @x1 = x
    @y1 = y
    @width = width
    @height = height
    @x2 = @x1 + @width
    @y2 = @y1 + @height
  end
end

class FabricSquare
  REGEX = /^#(\d+)\s@\s(\d+),(\d+):\s(\d+)x(\d+)$/.freeze

  def initialize
    @claims = parse_file
    @grid = Array.new(1000) { Array.new(1000, 0) }
  end

  def overlapping_squares_count
    @claims.each { |c| track_squares c }
    @grid.map { |row| row.select { |cell| cell > 1 }.size }.reduce(:+)
  end

  def find_non_overlapping_claim
    @claims.each do |claim1|
      overlaps = false
      @claims.each do |claim2|
        if overlap?(claim1, claim2)
          overlaps = true
          break
        end
      end

      return claim1 unless overlaps
    end
  end

  private

  def track_squares(claim)
    (claim.x1..claim.x2-1).each do |i|
      (claim.y1..claim.y2-1).each do |j|
        @grid[i][j] += 1
      end
    end
  end

  def overlap?(claim1, claim2)
    (
      claim1.x1 < claim2.x2 &&
      claim1.x2 > claim2.x1 &&
      claim1.y1 < claim2.y2 &&
      claim1.y2 > claim2.y1
    ) && claim1.id != claim2.id
  end

  def parse_file
    File.readlines('data.txt').map do |claim|
      Claim.new(*(REGEX.match(claim)[1..5].map(&:to_i)))
    end
  end
end

puts FabricSquare.new.overlapping_squares_count
puts FabricSquare.new.find_non_overlapping_claim.id
