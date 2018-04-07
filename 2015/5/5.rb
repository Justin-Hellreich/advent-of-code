VOWELS = /^.*[aeiou].*[aeiou].*[aeiou].*$/ # at least three vowels
DUPS = /^.*(.)\1.*$/ # consecutive duplicate character
BLACK_LIST = /^(?!.*(ab|cd|pq|xy)).*$/ # does not contain ab, cd, pq, xy
DUP_PAIR = /^.*(.{2}).*\1.*/ # duplicate pair
DUP_LETTER_WITH_SEPERATOR = /^.*(.).\1.*$/ # duplicate char with one char in middle

def test(rules)
  File.readlines('data.txt').map do |line|
    next 1 if rules.all? { |rule| rule =~ line }
    0
  end.reduce(:+)
end

puts "p1: #{test([ VOWELS, DUPS, BLACK_LIST ])}"
puts "p2: #{test([ DUP_PAIR, DUP_LETTER_WITH_SEPERATOR ])}"
