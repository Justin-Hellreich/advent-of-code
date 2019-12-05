class Password
  def initialize(password)
    @password = password.to_s.split('').map(&:to_i)
  end

  def valid?
    return false unless @password.size == 6
    return false unless @password.each_cons(2).any? { |a, b| a == b }
    return false unless @password == @password.sort
    true
  end
end

class PartTwoPassword < Password
  def valid?
    return false unless super
    return false unless [-1, @password, -1].flatten.each_cons(4).any? do |a, b, c, d|
      b == c && a != b && c != d
    end

    true
  end
end

bottom = 183564.freeze
top = 657474.freeze
puts (bottom..top+1).map { |pwd| Password.new(pwd).valid? ? 1 : 0 }.reduce(:+)
puts (bottom..top+1).map { |pwd| PartTwoPassword.new(pwd).valid? ? 1 : 0 }.reduce(:+)