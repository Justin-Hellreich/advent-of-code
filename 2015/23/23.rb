R_TYPE = /^(\w+)\s(\w)$/
I_TYPE = /^(\w+)\s([\+-]\d+)$/
J_TYPE = /^(\w+)\s(\w),\s([\+-]\d+)$/

def register(str)
  str.ord - 'a'.freeze.ord
end

INSTRUCTIONS = File.readlines('data.txt').map do |line|
  if (match_data = R_TYPE.match(line))
    { type: match_data[1].to_sym, arg: register(match_data[2]) }
  elsif (match_data = I_TYPE.match(line))
    { type: match_data[1].to_sym, arg: match_data[2].to_i }
  elsif (match_data = J_TYPE.match(line))
    { type: match_data[1].to_sym, arg1: register(match_data[2]), arg2: match_data[3].to_i }
  end
end

def execute(registers = Array.new(2, 0))
  instr_ptr = 0
  while instr_ptr < INSTRUCTIONS.size
    instruction = INSTRUCTIONS[instr_ptr]

    case instruction[:type]
    when :hlf
      registers[instruction[:arg]] /= 2
    when :tpl
      registers[instruction[:arg]] *= 3
    when :inc
      registers[instruction[:arg]] += 1
    when :jmp
      instr_ptr += instruction[:arg] and next
    when :jie
      instr_ptr += instruction[:arg2] and next if registers[instruction[:arg1]] % 2 == 0
    when :jio
      instr_ptr += instruction[:arg2] and next if registers[instruction[:arg1]] == 1
    end

    instr_ptr += 1
  end

  registers
end

puts "p1: #{execute.last}"
puts "p2: #{execute([1, 0]).last}"
