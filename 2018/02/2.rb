class Checksum
  def initialize
    parse_file
  end

  def compute_checksum
    count_repeats(repeats: 2) * count_repeats(repeats: 3)
  end

  def id_difference
    charArr1, charArr2 = matching_ids.map { |s| s.split '' }

    # hacky intersection since & doesn't work with duplicates
    # will break in lots of cases...
    non_matching_char = (charArr1 - charArr2)[0]
    charArr1.select { |c| c != non_matching_char }.join
  end

  # This is a bit inefficient
  def matching_ids
    @words.product(@words).detect { |pair| differ_by_one_char?(*pair) }
  end

  private

  def count_repeats(repeats:)
    @words.select { |str| appears?(str, repeats) }.size
  end

  def appears?(str, times)
    str.each_char.find { |c| str.count(c) == times }
  end

  def differ_by_one_char?(str1, str2)
    str1.each_char.zip(str2.each_char)
    .select { |x, y| x != y }.size == 1
  end

  def parse_file
    @words = File.readlines('data.txt')
  end
end

puts Checksum.new.compute_checksum
puts Checksum.new.id_difference
