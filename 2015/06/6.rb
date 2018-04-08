# input takes these three forms:
#   'toggle 258,985 through 663,998'
#   'turn on 601,259 through 831,486'
#   'turn off 914,94 through 941,102'
# this regex will capture the key word 'on, off, toggle'
# and then each of the four coordinates
REGEX = /^.*(off|on|toggle)\s(\d+)\,(\d+).{9}(\d+)\,(\d+)$/.freeze
LENGTH = 1000.freeze
INITIAL_VALUE = 0

# update light array
def update_lights(lights, coords, &light_control)
  x1, y1, x2, y2 = coords
  for i in (y1..y2)
    for j in (x1..x2)
      lights[i][j] = light_control.call(lights[i][j])
    end
  end
end

# handle a single line instruction (i.e. update a set of lights)
def execute_instruction(lights, line, &light_control)
  result = REGEX.match(line)

  # bind the expected action (e.g. 'on') to the proc so it doesn't
  # need to be passed through with the original light_control block
  binded_light_control = Proc.new { |light_val| light_control.call(result[1].to_sym, light_val) }

  update_lights(lights, result[2..5].map(&:to_i), &binded_light_control)
end

# execute all instructions, count how many are lit,
# take special function to compute new light value
def num_lit?(&light_control)
  lights = Array.new(LENGTH) { Array.new(LENGTH, INITIAL_VALUE) }
  File.readlines('data.txt').each { |line| execute_instruction(lights, line, &light_control) }
  lights.map { |light_row| light_row.reduce(:+) }.reduce(:+)
end

puts 'p1:', (num_lit? do |word_sym, cur_val|
  case word_sym
    when :on; 1
    when :off; 0
    when :toggle; cur_val == 1 ? 0 : 1
  end
end)

puts 'p2:', (num_lit? do |word_sym, cur_val|
  case word_sym
    when :on; cur_val + 1
    when :off; [cur_val - 1, 0].max
    when :toggle; cur_val + 2
  end
end)
