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
  end

  def get_total_overlapping
    overlapping_claims = get_overlapping_claims

    # TODO: need to track which squares are already overlapping
    overlapping_claims.map(&method(:overlapping_area)).sum
  end

  def get_overlapping_claims
    claims = []
    @claims.each.with_index do |claim1, i|
      @claims[i..-1].each do |claim2|
        claims << [claim1, claim2] if overlap?(claim1, claim2)
      end
    end

    claims
  end

  def overlapping_area(claim_pair)
    claim1, claim2 = claim_pair
    x = [claim1.x2, claim2.x2].min - [claim1.x1, claim2.x1].max
    y = [claim1.y2, claim2.y2].min - [claim1.y1, claim2.y1].max

    x * y
  end

  private

  def overlap?(claim1, claim2)
    (
      claim1.x1 < claim2.x1 &&
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

puts FabricSquare.new.get_total_overlapping
