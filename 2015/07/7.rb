# extend fixnum to define a special complement method,
# (since my circuit implementation uses Fixnum member methods).
# since ruby numbers are not unsigned, use this hacky
# unsigned 16 bit complement operator.
class Fixnum
  def not
    2 ** 16 - self - 1
  end
end

class Circuit
  ASSIGNMENT = /^(.*)\s->\s(.*)$/.freeze # e.g. 500 -> x
  UNARY = /^(.*)\s(.*)\s->\s(.*)$/.freeze # e.g. NOT 500 -> x
  BINARY = /^(.*)\s(.*)\s(.*)\s->\s(.*)$/.freeze # e.g. x AND y -> z
  IS_NUMBER = /^\d+$/
  OPERATORS = {
    NOT: :not,
    LSHIFT: :<<,
    RSHIFT: :>>,
    AND: :&,
    OR: :|
  }.freeze

  def initialize
    @circuit = {}
    read_file { |line| parse_line(line) } # build circuit hash
  end

  def find(node_sym)
    # base case (reduced to a num)
    return node_sym if node_sym.is_a? Numeric

    # memoized case
    return @circuit[node_sym][:val] if @circuit[node_sym][:val] && @circuit[node_sym][:val].is_a?(Numeric)

    # recurse and memoize
    @circuit[node_sym][:val] = send(@circuit[node_sym][:type], @circuit[node_sym])
  end

  # override the value at a given node
  def override(node_sym, val)
    @circuit[node_sym][:val] = val
    self # for chaining
  end

  private

  # execute the unary method on a given node's child
  # the child is found recursively
  def unary(node)
    find(node[:var]).send(node[:op])
  end

  # execute the unary method on a given node's child
  # the children are found recursively
  def binary(node)
    find(node[:var1]).send(node[:op], find(node[:var2]))
  end

   def read_file
    File.readlines('data.txt').each { |line| yield line }
  end

  # build a hash of nodes
  def parse_line(line)
    # pull match with the most groups
    match = [ASSIGNMENT, UNARY, BINARY].map { |regex| regex.match(line) }.compact.max_by(&:size)

    case match.size
      when 3 # just assignment
        @circuit[match[2].to_sym] = { op: :itself, type: :unary, var: num_or_sym(match[1]) }
      when 4 # just not
        @circuit[match[3].to_sym] = { op: OPERATORS[match[1].to_sym], type: :unary, var: num_or_sym(match[2]) }
      when 5 # lshift, rshift, and, or
        @circuit[match[4].to_sym] = {
          op: OPERATORS[match[2].to_sym], type: :binary,
          var1: num_or_sym(match[1]), var2: num_or_sym(match[3])
        }
    end
  end

  # if str is numeric, cast to int, otherwise cast to symbol
  def num_or_sym(str)
    IS_NUMBER =~ str ? str.to_i : str.to_sym
  end
end

a_val = Circuit.new.find(:a)
puts "p1: #{a_val}"
a_val = Circuit.new.override(:b, a_val).find(:a)
puts "p2: #{a_val}"
