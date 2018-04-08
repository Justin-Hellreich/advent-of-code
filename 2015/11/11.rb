class PasswordGenerator
  BLACK_LIST = /^[^iol]+$/.freeze
  DUP_PAIRS = /^.*(.)\1.*(.)\2.*$/.freeze

  def initialize(pw)
    @triples = ('a'..'z').to_a.each_cons(3).to_a.map(&:join) # ['abc', 'bcd', ...]
    @pw = pw
  end

  def gen
    begin @pw = @pw.next; end while !is_secure?(@pw) # makeshift do-while
    @pw
  end

  private

  def is_secure?(pw)
    return false unless @triples.detect { |triple| pw.include?(triple) }
    return false unless BLACK_LIST =~ pw

    match = DUP_PAIRS.match(pw)
    return false unless match && match[1] != match[2] # refuse duplicate pairs

    true
  end
end

pw_gen = PasswordGenerator.new('hepxcrrq')
puts "p1: #{pw_gen.gen}"
puts "p2: #{pw_gen.gen}"
