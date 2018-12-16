def reduce(str)
  return 0 if str.empty?

  prevSize = str.size
  i, j = [0, 1]
  while (j < str.size)
    if (str[i].ord - str[j].ord).abs == 32 # hacky upper/lower check
      str[i] = ''
      str[j-1] = '' # str is one smaller now
    else
      i, j = [i + 1, j + 1]
    end
  end

  return str.size if prevSize == str.size

  reduce(str)
end

str = File.read('data.txt')
puts reduce str

lengths = []
('x'..'x').each do |c|
  upper_c = c.upcase
  testStr = str.split('').select { |s| c != s && upper_c != s }.join
  lengths << reduce(testStr)
end
puts lengths.min
