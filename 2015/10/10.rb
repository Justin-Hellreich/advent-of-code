# inspiration for fastest solution from here
# https://rosettacode.org/wiki/Look-and-say_sequence#Ruby

INPUT = '3113322113'
REGEX = /(\d)\1*/.freeze

def look_and_say(str)
  str.gsub(REGEX) { |s| "#{s.size}#{s[0]}" }
end

str = INPUT
40.times { str = look_and_say(str) }
puts "p1: #{str.size}"

str = INPUT
50.times { str = look_and_say(str) }
puts "p2: #{str.size}"
