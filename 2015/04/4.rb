require 'digest'

def find_hash(num_zeroes_prefix: 5)
	test_result = '0' * num_zeroes_prefix
	i = 0
	i += 1 while Digest::MD5::hexdigest("iwrupvqb#{i}")[0..(num_zeroes_prefix - 1)] != test_result
	i
end

puts "p1: #{find_hash(num_zeroes_prefix: 5)}"
puts "p1: #{find_hash(num_zeroes_prefix: 6)}"
