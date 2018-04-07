require 'set'

# Solution using lots of parsing

p1 = false # toggle for part
VOWELS = 'aeiou'.chars.to_set
REJECTED = ['ab', 'cd', 'pq', 'xy'].to_set

def read_file
	puts File.readlines('data.txt').map { |line| yield line }.reduce(:+)
end


read_file do |str|
	pair_char_array = str.chars.each_cons(2).map(&:itself).map(&:join)
	pair_char_set = pair_char_array.to_set

	if p1
		next 0 if str.chars.select { |c| VOWELS.include? c }.size < 3 # intersect and count
		next 0 if pair_char_set.select { |pair| pair[0] == pair[1] }.size == 0 # equal pair
		next 0 if (pair_char_set & REJECTED).size >= 1 # has rejected letter
	else
		# has no pairs OR has equal pairs next to each other (https://stackoverflow.com/a/2516496)
		next 0 if pair_char_array.uniq.size == pair_char_array.size || pair_char_array.chunk(&:itself).map(&:first).size < pair_char_array.size

		# repeating letter with one in between
		next 0 unless str.chars.each_cons(3).select { |triple| triple[0] == triple[2] }.size > 0
	end
	1
end
