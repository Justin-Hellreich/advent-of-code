class PowerGrid
  def initialize(serial_num:)
    @serial_num = serial_num
    @grid = Array.new(300) do |i|
      Array.new(300) do |j|
        power_level(i+1, j+1)
      end
    end
  end

  def max_power_cell
    cell = power_cells.max_by { |c| c[:cell_power] }
    "#{cell[:x]},#{cell[:y]}"
  end

  private

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

