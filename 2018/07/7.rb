class Graph
  REGEX = /Step\s(\w).*step\s(\w).*/
  TIME_STEP = 60

  def initialize
    parse_file
  end

  def topological_sort
    sorted = []
    loop do
      c = next_node!
      break if c.nil?
      sorted << c
    end

    sorted.join
  end

  def timed_topological_sort
    available_workers = 5

    in_progress = {}
    time = 0
    loop do
      _next_nodes = next_nodes
      break if _next_nodes.empty?
      _next_nodes.each do |key|
        break if available_workers == 0
        in_progress[key] = key.to_s.ord - 64 + TIME_STEP unless in_progress.key? key
        available_workers -= 1 unless in_progress.key? key
      end

      while !in_progress.empty?
        to_delete = []
        in_progress.each { |key, time| to_delete << key if time == 0 }
        to_delete.each do |key| 
          in_progress.delete key
          @graph.delete key
          available_workers += 1
        end

        break if in_progress.empty? || !to_delete.empty?

        in_progress = in_progress.transform_values { |t| t -= 1}
        time += 1
      end
    end

    time
  end

  private

  def next_nodes
    found_keys = []
    @graph.each do |key, _|
      found_keys << key if @graph.all? { |_, children| !children.include? key }
    end

    found_keys.sort
  end

  def next_node!
    found_keys = next_nodes
    return nil if found_keys.empty?

    @graph.delete found_keys[0]
    found_keys[0]
  end

  def parse_file
    @graph = {}
    File.readlines('data.txt').each do |line|
      from, to = REGEX.match(line)[1..2].map(&:to_sym)
      (@graph[from] ||= []) << to
    end

    add_tails
    pre_order
  end

  def add_tails
    keys = @graph.keys
    keys.each do |key|
      @graph[key].each do |child_key|
        @graph[child_key] = [] unless @graph.key?(child_key)
      end
    end
  end

  def pre_order
    @graph = Hash[@graph.sort.reverse]
    @graph.transform_values! { |children| children.sort.reverse }
  end
end

puts Graph.new.topological_sort
puts Graph.new.timed_topological_sort
