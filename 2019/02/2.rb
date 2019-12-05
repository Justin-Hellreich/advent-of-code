class Intcode
  def initialize(noun, verb)
    @sequence = parse_file
    @sequence[1] = noun
    @sequence[2] = verb
  end

  def process
    instr_ptr = 0
    instr_ptr = process_instruction(instr_ptr) while true rescue
    @sequence[0]
  end

  private

  ADD = 1.freeze
  MULT = 2.freeze
  HALT = 99.freeze

  def process_instruction(i)
    case @sequence[i]
    when HALT
      raise
    when ADD
      op = :+
    when MULT
      op = :*
    end

    operand_one_index, operand_two_index, overwrite_index = [@sequence[cyclic_index(i, 1)], @sequence[cyclic_index(i, 2)], @sequence[cyclic_index(i, 3)]]
    @sequence[overwrite_index] = @sequence[operand_one_index].send(op, @sequence[operand_two_index])
    cyclic_index(i, 4) # next op
  end

  def cyclic_index(i, increment)
    (i + increment) % @sequence.size
  end

  def parse_file
    File.read('data.txt').split(',').map(&:to_i)
  end
end

class OutputFinder
  def initialize(output)
    @output = output
  end

  def start
    100.times do |i|
      100.times do |j|
        return [i, j] if Intcode.new(i, j).process == @output
      end
    end
  end
end

puts Intcode.new(12, 2).process

noun, verb = OutputFinder.new(19690720).start
puts 100 * noun + verb