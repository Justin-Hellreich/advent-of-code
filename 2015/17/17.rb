# recursive solution to find the number of
# ways containers can add to total
# provide size field to limit count to
# a specific size of a solution
def count(total, containers, size = nil)
  return 1 if total == 0 && (size.nil? || size == 0)
  return 0 if containers.empty? || total < 0

  count(total - containers.first, containers.drop(1), size.nil? ? nil : size - 1) + 
  count(total, containers.drop(1), size || nil)
end

# Dynamic programming table to find the min
# number of containers to make up the given total.
# d[i, j] is the min number of containers in the first
# i containers which can make up total j.
# d[i, j] either uses container i, or it doesn't, so
# d[i, j] = min(d[i-1][j], 1 + d[i][j - container[i]])
# TODO: rewrite this to track number of solutions, so the 
# recursive function isn't needed
def min(total, containers)
  d = Array.new(containers.size) { Array.new(total + 1) }
  d[0] = Array.new(total + 1) { |i| i }
  containers.size.times { |i| d[i][0] = 0 }

  for i in (1..containers.size - 1)
    for j in (1..total)
      result = [d[i - 1][j]]
      result << (1 + d[i][j - containers[i]]) unless containers[i] > j
      d[i][j] = result.min
    end
  end

  d[containers.size - 1][total]
end

TOTAL = 150.freeze
containers = File.readlines('data.txt').map(&:to_i)
puts "p1: #{count(TOTAL, containers)}"
min_val = min(TOTAL, containers)
puts "p2: #{count(TOTAL, containers, min_val)}"