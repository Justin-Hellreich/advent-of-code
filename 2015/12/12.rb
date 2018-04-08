def sum_nums(should_exclude_red = false)
  obj = eval(File.read('data.txt')) # hack to parse input

  # flatten until no more elements are hashes
  while obj.any? { |el| el.is_a? Hash }
    obj = obj.map do |el|
      next el unless el.is_a?(Hash)

      el.values.include?('red') && should_exclude_red ? [] : el.values
    end.flatten
  end

  # sum all numerics
  obj.reduce(0) { |sum, el| sum + (el.is_a?(Numeric) ? el : 0) }
end

puts "p1: #{sum_nums}"
puts "p2: #{sum_nums(true)}"
