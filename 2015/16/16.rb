class AuntSue
  def initialize(fields)
    @fields = fields
  end
end

REGEX = /(?:(\w+):\s(\d+),*[\s]*)/.freeze
File.read('mystery_sue.txt') do |line|
  matchline.scan(REGEX)
end
