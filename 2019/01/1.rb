class Rocket
	def initialize
		@module_masses = parse_file
	end

	def fuel_requirements
		@module_masses.map { |m| fuel(m) }.reduce(:+)
	end

	private

	def parse_file
    File.readlines('data.txt').map(&:to_i)
  end
end

class PartOneRocket < Rocket
	def fuel(mass)
		mass / 3 - 2
	end
end

class PartTwoRocket < Rocket
	def fuel(mass)
		return 0 if mass <= 0

		_fuel = mass / 3 - 2
		_fuel = 0 if _fuel < 0
		_fuel + fuel(_fuel)
	end
end

puts PartOneRocket.new.fuel_requirements
puts PartTwoRocket.new.fuel_requirements