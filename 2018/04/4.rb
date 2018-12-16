require 'date'

class Record
  attr_accessor :id
  attr_reader :type, :datetime

  DATETIME = /\[(.*)\](.*)/
  BEGINS_SHIFT = /.*(Guard)\s#(\d*).*/
  FALLS_ASLEEP = /.*(falls).*/
  WAKES_UP = /.*(wakes).*/

  def initialize(str)
    datetime, message = DATETIME.match(str)[1..2]
    @datetime = DateTime.parse(datetime)

    case message
    when BEGINS_SHIFT
      @type = :begins_shift
      @id = $2.to_i
    when FALLS_ASLEEP
      @type = :falls_asleep
    when WAKES_UP
      @type = :wakes_up
    end
  end
end

class RecordSet
  def initialize
    @records = parse_file
    sort!
    distribute_ids!
  end

  def sleepy_value
    id = sleepiest_guard
    minute = sleepiest_minute(id)[1]
    id * minute
  end

  def most_frequently_asleep
    guard_frequency = []
    guard_ids.each do |id|
      freq, min = sleepiest_minute id
      guard_frequency << {id: id, min: min, freq: freq}
    end

    guard = guard_frequency.max_by { |g| g[:freq] }
    guard[:id] * guard[:min]
  end

  private

  MINUTE = (1.0/24/60)

  def sleepiest_minute(id)
    pairs = sleepy_pairs(id)

    minutes = Array.new (60) { 0 }
    minutes.each.with_index do |_, i|
      pairs.each do |r1, r2|
        m_datetime = set_minute(r1.datetime, i)
        minutes[i] += 1 if m_datetime.between?(r1.datetime, r2.datetime - MINUTE)
      end
    end

    minutes.each.with_index.max
  end

  def set_minute(d, m)
    DateTime.new(d.year, d.month, d.day, d.hour, m, 0)
  end 

  def sleepiest_guard
    guard_ids.map { |id| [id, time_asleep(id)] }.max_by { |_, t| t }[0]
  end

  def guard_ids
    @records.map(&:id).uniq
  end

  def time_asleep(id)
    sleepy_pairs(id).map { |r1, r2| time_diff_minutes(r1, r2) }.sum
  end

  def sleepy_pairs(id)
    @records
      .select { |r| r.id == id }
      .each_cons(2)
      .select { |r1, r2| r1.type == :falls_asleep && r2.type == :wakes_up }
  end

  def time_diff_minutes(r1, r2)
    ((r2.datetime - r1.datetime) * 24 * 60).to_i
  end

  def sort!
    @records.sort_by! { |r| r.datetime }
  end

  def distribute_ids!
    id = @records[0].id
    for i in (1..@records.size-1)
      id = @records[i].id if @records[i].type == :begins_shift
      while (i < @records.size && @records[i].type != :begins_shift)
        @records[i].id = id
        i += 1
      end
    end
  end

  def parse_file
    File.readlines('data.txt').map { |r| Record.new r }
  end
end

puts RecordSet.new.sleepy_value
puts RecordSet.new.most_frequently_asleep
