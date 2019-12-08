class Op
  def initialize(sequence, index)
    @sequence = sequence
    @index = index
    @immediate = [false, false] # no ops have more than two possible immediate params
  end

  def set_immediate(param_num, immediate)
    @immediate[param_num] = immediate
  end

  protected

  def exec(instr_len)
    [@sequence, cyclic_index(@index, instr_len)] # updated sequence + next op index
  end

  def operand_index(offset)
    if @immediate[offset-1]
      cyclic_index(@index, offset)
    else
      @sequence[cyclic_index(@index, offset)]
    end
  end

  def cyclic_index(i, increment)
    (i + increment) % @sequence.size
  end
end

class Jump < Op
  def initialize(if_true, sequence, index)
    @if_true = if_true
    super(sequence, index)
  end

  def exec
    return [@sequence, cyclic_index(@sequence[operand_index(2)], 0)] if jump?(@sequence[operand_index(1)])
    super(3) # don't jump
  end

  private

  def jump?(val)
    return true if @if_true && val != 0
    return true if !@if_true && val == 0
    false
  end
end

class Comp < Op
  def initialize(operator, sequence, index)
    @operator = operator
    super(sequence, index)
  end

  def exec
    operand_one_index, operand_two_index, overwrite_index = [operand_index(1), operand_index(2), @sequence[cyclic_index(@index, 3)]]
    @sequence[overwrite_index] = @sequence[operand_one_index].send(@operator, @sequence[operand_two_index]) ? 1 : 0
    super(4)
  end
end

class Input < Op
  def exec
    puts "input: "
    input = gets.chomp.to_i # TODO: hardcode this for actual impl
    @sequence[@sequence[cyclic_index(@index, 1)]] = input
    super(2)
  end
end

class Output < Op
  def exec
    puts "Output #{@sequence[operand_index(1)]}"
    super(2)
  end
end

class Arithmetic < Op
  def initialize(operator, sequence, index)
    @operator = operator
    super(sequence, index)
  end

  def exec
    operand_one_index, operand_two_index, overwrite_index = [operand_index(1), operand_index(2), @sequence[cyclic_index(@index, 3)]]
    @sequence[overwrite_index] = @sequence[operand_one_index].send(@operator, @sequence[operand_two_index])
    super(4)
  end
end

class Intcode
  def initialize
    @sequence = parse_file
  end

  def process
    instr_ptr = 0
    instr_ptr = process_instruction(instr_ptr) while true rescue
    @sequence[0]
  end

  private

  ADD = 1.freeze
  MULT = 2.freeze
  INPUT = 3.freeze
  OUTPUT = 4.freeze
  JUMP_TRUE = 5.freeze
  JUMP_FALSE = 6.freeze
  LT = 7.freeze
  EQ = 8.freeze
  HALT = 99.freeze

  def process_instruction(i)
    op = get_op(@sequence[i], i)

    @sequence, next_op_index = op.exec
    next_op_index
  end

  def get_op(code, index)
    case code
    when HALT
      raise
    when ADD
      Arithmetic.new(:+, @sequence, index)
    when MULT
      Arithmetic.new(:*, @sequence, index)
    when INPUT
      Input.new(@sequence, index)
    when OUTPUT
      Output.new(@sequence, index)
    when JUMP_TRUE
      Jump.new(true, @sequence, index)
    when JUMP_FALSE
      Jump.new(false, @sequence, index)
    when LT
      Comp.new(:<, @sequence, index)
    when EQ
      Comp.new(:==, @sequence, index)
    else # parameter mode
      op_arr = @sequence[index].to_s.split('')
      op = get_op(op_arr.pop(2).join.to_i, index)
      op_arr.reverse.each.with_index { |immediate, i| op.set_immediate(i, immediate == '1') }
      op
    end
  end

  def parse_file
    File.read('data.txt').split(',').map(&:to_i)
  end
end

Intcode.new.process # give input 1
Intcode.new.process # give input 5
