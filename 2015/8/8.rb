# each string in data.txt has a newline, so subtract one from the length for each
# i.e. there needs to be a newline at the end of the file
puts 'p1:', File.readlines('data.txt').map { |line| line.size - eval(line).size - 1 }.reduce(:+)
puts 'p2:', File.readlines('data.txt').map { |line| line.dump.size - line.size - 1 }.reduce(:+)
