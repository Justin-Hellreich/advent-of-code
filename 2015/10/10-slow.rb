INPUT = '3113322113'

def look_and_say(str)
  new_str = ''

  while str != ''
    new_num = count_consecutive(str)
    new_str << new_num.to_s
    new_str << str[0] # append old num

    # remove all consecutive nums from start
    str[0..new_num-1] = ''
  end

  new_str
end

def count_consecutive(str)
  i = 1
  i += 1 while str[i] == str[0]
  i
end

str = INPUT
40.times { str = look_and_say(str) }
puts "p1: #{str.size}"

str = INPUT
50.times { str = look_and_say(str) } # this'll take a while..
puts "p2: #{str.size}"
