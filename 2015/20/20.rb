NUM = 36000000.freeze

def find_first_house(multipler:, delivery_limit: Float::INFINITY)
  houses = Array.new(NUM / 10, 0)
  found_houses = []
  deliver_count = []
  for i in (1..NUM/10-1)
    r = 0
    (i..NUM/10-1).step(i) do |j|
      next if r >= delivery_limit

      houses[j] += (i * multipler)
      found_houses << j if houses[j] >= NUM

      r += 1
    end
  end

  found_houses.min
end

puts "p1: #{find_first_house(multipler: 10)}"
puts "p2: #{find_first_house(multipler: 11, delivery_limit: 50)}"
