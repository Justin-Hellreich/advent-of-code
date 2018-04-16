class Generator
  REGEX = /^(\w+)\s=>\s(\w+)$/.freeze

  def initialize
    read_file
  end

  def one_iteration
    scan(@test_str).size
  end

  def reduce
    str = @test_str
    i = 0
    while (str != 'e')
      @rules.each do |rule|
        new_str = str.sub(rule[1].to_s, rule[0].to_s)
        i += 1 if new_str != str
        str = new_str
      end
    end

    i
  end

  private

  def scan(str)
    replacements = []

    @rules.each do |mapping|
      key, val = mapping
      str.count(key.to_s).times do |i| # for every occurrence
        replacements << str.gsub(key.to_s).with_index do |cur, j| # replace individual occurrences
          next val.to_s if i == j
          cur if i != j
        end.strip
      end
    end

    replacements.uniq
  end

  def read_file
    @rules = []
    File.readlines('data.txt').each do |line|
      next if line.strip == ''

      match_data = REGEX.match(line)
      @test_str = line.strip and return if match_data.nil?
      @rules << [match_data[1].to_sym, match_data[2].to_sym]
    end
  end
end

puts "p2: #{Generator.new.one_iteration}"
puts "p2: #{Generator.new.reduce}"

