def find_floor
	floor = 0
	File.read('data.txt').split('').each_with_index do |char, i|
		floor += (char == '(' ? 1 : -1)
		break if (block_given? && yield(floor, i)) # expose block with control to break
	end

	floor
end

puts "p1: #{find_floor}"
find_floor do |floor, i|
	if floor == -1
		puts "p2: #{i + 1}" # 1 based positoon
		true # break execution
	end
end
