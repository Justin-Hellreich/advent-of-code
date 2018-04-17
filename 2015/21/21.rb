class Player
  # no need to expose @damage and @armor because of the observer-ish pattern
  attr_accessor :points

  def initialize(points, damage, armor)
    @points = points
    @damage = damage
    @armor = armor
  end

  def attack(player) # notify other player of attack
    player.notify(@damage)
  end

  protected

  def notify(damage) # notified of attack, update self
    @points -= (hit = damage - @armor) > 0 ? hit : 1
  end
end

class Game
  def initialize(user, boss)
    @user = user
    @boss = boss
  end

  def simulate
    while @user.points > 0 && @boss.points > 0
      @user.attack(@boss)
      @boss.attack(@user)
    end

    @boss.points <= 0
  end
end


STORE = {
  weapons: [ [8, 4], [10, 5], [25, 6], [40, 7], [74, 8] ],
  armors: [[13, 1], [31, 2], [53, 3], [75, 4], [102, 5], [0, 0] ],
  rings: [
    [25, 1, 0], [50, 2, 0], [100, 3, 0], [20, 0, 1], [40, 0, 2], [80, 0, 3], [0, 0, 0]
  ].combination(2).to_a
}

def find_costs(should_win:)
  costs = []
  STORE[:weapons].each do |weapon|
    STORE[:armors].each do |armor|
      STORE[:rings].each do |ring|
        cost = weapon[0] + armor[0] + ring[0][0] + ring[1][0]
        damage_val = weapon[1] + ring[0][1] + ring[1][1]
        armor_val = armor[1] + ring[0][2] + ring[1][2]

        user = Player.new(100, damage_val, armor_val)
        boss = Player.new(104, 8, 1) # provided input
        costs << cost if Game.new(user, boss).simulate == should_win
      end
    end
  end

  costs
end

puts "p1: #{find_costs(should_win: true).min}"
puts "p2: #{find_costs(should_win: false).max}"
