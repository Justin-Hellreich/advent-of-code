class Garden
  def initialize
    @state = []
    @rules = {}
    @center = 2
    parse_file
  end

  def iterate(n)
    n.times { |i| set_state one_iteration(@state[i]) }
    self
  end

  def num_plants(n = nil)
    @state[n || 20].chars.each_with_index.map { |c, i| c == '#' ? i - @center : 0 }.sum
  end

  private

  def one_iteration(state)
    puts "#{num_plants(@state.size - 1)} #{@state.size - 1}"

    state = state.chars.each_cons(5).map do |str|
      "..#{@rules[str.join] || '.'}.."
    end

    state.map { |str| str[2] }.join
  end

  def set_state(state)
    @state[@state.size] = ".....#{state}....."
    @center += 3
  end

  def parse_file
    first_line = true
    File.readlines('data.txt').each do |line|
      next if line.strip == ''

      if first_line
        set_state line[15..-1].strip
        first_line = false
        next
      end

      rule = line.split(' => ').map(&:strip)
      @rules[rule[0]] = rule[1]
    end
  end
end

puts Garden.new.iterate(20).num_plants

# for part 2, after a couple hundred generations
# it starts incrementing regularly
puts Garden.new.iterate(1000).num_plants
