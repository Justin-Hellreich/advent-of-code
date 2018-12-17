class CircularArray
  attr_accessor :array

  def initialize(array)
    @array = array
  end

  def at(i)
    array.at index i
  end

  def insert(n, at:)
    i = index(at)
    @array.insert(i, n)
    i
  end

  def delete(at: )
    @array.delete_at(at % (array.size - 1))
  end

  private

  def index(i)
    i % array.size
  end
end

class Game
  def initialize
    @players, @last_marble = parse_file
  end

  def play
    circle = CircularArray.new [0, 1]
    turn = 2
    current_marble_index = 1
    scores = Array.new(@players) { 0 }

    while turn < @last_marble
      puts turn if (turn % 10000 == 0)
      #puts "#{turn} #{current_marble_index} #{circle.array.inspect}"
      if turn % 23 != 0
        current_marble_index = circle.insert(turn, at: current_marble_index + 2)
      else
        scores[turn % @players] += turn
        current_marble_index -= 7
        scores[turn % @players] += circle.delete(at: current_marble_index)
      end

      turn += 1
    end

    scores.max
  end

  private

  REGEX = /(\d*).*\s(\d*)\s.*/
  def parse_file
    REGEX.match(File.read('data.txt'))[1..2].map(&:to_i)
  end
end

puts Game.new.play.inspect