class PowerGrid
  def initialize(serial_num:)
    @serial_num = serial_num
    @grid = Array.new(300) do |i|
      Array.new(300) do |j|
        power_level(i+1, j+1)
      end
    end
  end

  def compute_grid
    arr = []
    (0..299).each do |i|
      arr[i] = []
      (0..299).each do |j|
        arr[i][j] = []
      end
    end

    (0..299).each do |i|
      (0..299).each do |j|
        arr[i][j][0] = 0
        arr[i][j][1] = p(i, j)
      end
    end

    (0..299).each do |w|
      (0..299).each do |h|
        (2..299).each do |size|
          if size + w > 299 || size + h > 299
            arr[w][h][size] = -Float::INFINITY
            next
          end

          # these can be factored out to save a ton of time
          sum_1 = (h..(h + size - 1)).map { |i| p(w + size - 1, i) }.sum
          sum_2 = (w..(w + size - 1)).map { |i| p(i, h + size - 1) }.sum
          arr[w][h][size] = arr[w][h][size - 1] + sum_1 + sum_2 - p(w + size - 1, h + size - 1)
        end
      end
    end

    max = -Float::INFINITY
    _i, _j, _k = 0
    (0..299).each do |i|
      (0..299).each do |j|
        (0..299).each do |k|
          if arr[i][j][k] > max
            _i = i
            _j = j
            _k = k
            max = arr[i][j][k]
          end
        end
      end
    end

    puts "(#{_i + 1},#{_j + 1},#{_k})"
  end

  def max_power_cell
    cell = power_cells.max_by { |c| c[:cell_power] }
    "#{cell[:x]},#{cell[:y]}"
  end

  private

  def p(x, y)
    @grid[x][y]
  end

  RANGE = (1..297)
  def power_cells
    cells = []
    RANGE.each do |i|
      RANGE.each do |j|
        cells << {
          cell_power: cell_power(i-1, j-1, 3),
          x: i,
          y: j,
          size: 3
        }
      end
    end

    cells
  end

  def cell_power(x, y, size)
    return 0 if x + size >= 300 || y + size >= 300
    @grid[x..x+size-1].map { |row| row[y..y+size-1].reduce(:+) }.reduce(:+)
  end

  def power_level(x, y)
    hundreds_digit(
      (rack_id(x) * y + @serial_num) * rack_id(x)
    ) - 5
  end

  def rack_id(x)
    x + 10
  end

  def hundreds_digit(n)
    n / 100 % 10
  end
end

puts PowerGrid.new(serial_num: 9221).max_power_cell
puts PowerGrid.new(serial_num: 9221).compute_grid

