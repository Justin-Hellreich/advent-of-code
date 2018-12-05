class Frequency
  def initialize
    @ops = parse_file
  end

  def compute_frequency
    @ops.sum
  end

  # This is quite slow...
  def repeated_frequency
    cur_freq = 0
    freqs = []
    i = 0
    while (!(freqs.include? cur_freq))
      i = 0 if i == @ops.size

      freqs << cur_freq
      cur_freq += @ops[i]

      i += 1
    end

    cur_freq
  end

  def parse_file
    File.readlines('data.txt').map(&:to_i)
  end
end

puts Frequency.new.compute_frequency
puts Frequency.new.repeated_frequency
