# cur_loc = { x: 0, y: 0 }
# santa_loc = { x: 0, y: 0 }
# robo_loc = { x: 0, y: 0 }
SYM_DIR = { '^': :y, 'v': :y, '>': :x, '<': :x }.freeze
SYM_VAL = { '^': 1, 'v': -1, '>': 1, '<': -1 }.freeze

def deliver(num_deliverers = 1)
  visitor_locs = Array.new(num_deliverers, { x: 0, y: 0 })
  visited = []
  visitor_locs.each { |loc| visited << loc.values.clone }

  # expects data.txt to not have a new line
  File.read('data.txt').chars.map(&:to_sym).each_with_index do |char, i|
    cur_visitor = i % num_deliverers

    # update current location of visitor
    loc = visitor_locs[cur_visitor].clone
    loc[SYM_DIR[char]] += SYM_VAL[char]
    visitor_locs[cur_visitor] = loc

    visited << visitor_locs[cur_visitor].values
  end

  visited.uniq.count
end

puts "p1: #{deliver(1)}"
puts "p2: #{deliver(2)}"
