class Node
  attr_reader :children, :metadata

  def initialize
    @children = []
  end

  def add(child)
    @children << child
  end

  def set(metadata)
    @metadata = metadata
  end

  def leaf?
    children.empty?
  end
end

class Tree
  def initialize
    @tree = parse_file
  end

  def sum_metadata(tree = @tree)
    return tree.metadata.sum if tree.leaf?

    tree.metadata.sum + tree.children.map do |n| 
      sum_metadata(n)
    end.sum
  end

  def value(node = @tree)
    return 0 if node.nil?
    return node.metadata.sum if node.leaf?

    node.metadata.map do |md|
      value(node.children[md-1])
    end.sum
  end

  private

  def print(tree)
    return if tree.nil?

    puts tree.metadata.inspect
    tree.children.each { |n| print n }
  end

  def build(values)
    return nil if values.empty?

    tree = Node.new

    num_children, num_metadata = values.shift(2)

    num_children.times do
      tree.add(build(values))
      num_children -= 1
    end

    if num_children == 0
      tree.set(values.shift(num_metadata))
    end

    tree
  end

  def metadata!(values, count)
    values.pop(count)
  end

  def parse_file
    build File.read('data.txt').split(' ').map(&:to_i)
  end
end

puts Tree.new.sum_metadata
puts Tree.new.value
