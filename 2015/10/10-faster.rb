INPUT = '3113322113'
REGEX = /(\d)\1*/.freeze

def look_and_say(str)
  new_str = ''

  while str != ''
    len, num = REGEX.match(str)[0..1]
    new_str << "#{len.size}#{num}"
    str[0..len.size - 1] = ''
  end

  new_str
end

str = INPUT
40.times { str = look_and_say(str) }
puts "p1: #{str.size}"

str = INPUT
50.times { str = look_and_say(str) } # this *may* run out of memory
puts "p2: #{str.size}"
