class Node
  attr_accessor :next, :prev, :val

  def initialize(val)
    @next = nil
    @prev = nil
    @val = val
  end
end

class Game
  def initialize(times: 1)
    @players, @last_marble = parse_file
    @last_marble = @last_marble * times
  end

  def play
    current_marble = mk_default_double_dir_circular_linked_list.next
    turn = 2
    scores = Array.new(@players) { 0 }

    while turn < @last_marble
      if turn % 23 != 0 # insert after next node
        after_new_node = current_marble.next.next
        current_marble.next.next = Node.new turn
        current_marble.next.next.prev = current_marble.next
        current_marble.next.next.next = after_new_node
        current_marble.next.next.next.prev = current_marble.next.next
        current_marble = current_marble.next.next
      else
        scores[turn % @players] += turn
        current_marble = current_marble.prev.prev.prev.prev.prev.prev.prev
        scores[turn % @players] += current_marble.val
        current_marble = current_marble.next
        current_marble.prev.prev.next = current_marble
      end

      turn += 1
    end

    scores.max
  end

  private

  def mk_default_double_dir_circular_linked_list
    el1 = Node.new 0
    el2 = Node.new 1
    el1.next = el2
    el2.next = el1
    el2.prev = el1
    el1.prev = el2

    el1
  end

  def print(node)
    root = node.val
    nums = [root]

    node = node.next
    while (node.val != root)
      nums << node.val
      node = node.next
    end

    puts nums.inspect
  end

  REGEX = /(\d*).*\s(\d*)\s.*/
  def parse_file
    REGEX.match(File.read('data.txt'))[1..2].map(&:to_i)
  end
end

puts Game.new.play
puts Game.new(times: 100).play