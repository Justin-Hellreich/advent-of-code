def paper_size(l:, w:, h:)
	areas = [l * w, w * h, h * l]
	areas.map { |area| area * 2 }.reduce(:+) + areas.min
end

def ribbon_size(dims)
	dims.map { |_, v| v * 2 }
	perimeters = [ 2 * dims[:l] + 2 * dims[:w], 2 * dims[:w] + 2 * dims[:h], 2 * dims[:h] + 2 * dims[:l] ]
	perimeters.min + dims.values.reduce(:*)
end

def read_file
	File.readlines('data.txt').map do |line|
		dim = line.split('x')
		yield({ l: dim[0].to_i, w: dim[1].to_i, h: dim[2].to_i })
	end.reduce(:+)
end

puts read_file { |h| paper_size(h) }
puts read_file { |h| ribbon_size(h) }
