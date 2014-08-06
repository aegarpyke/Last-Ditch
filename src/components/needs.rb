class Needs < Component

  attr_accessor :hunger, :thirst, :sanity
  attr_accessor :hunger_rate, :thirst_rate, :sanity_rate
  attr_accessor :energy, :energy_max, :energy_fatigue_rate, :energy_recovery_rate, :energy_usage_rate

  def initialize
    super()

    @hunger = 1.0
    @hunger_rate = -0.000027
    @thirst = 1.0
    @thirst_rate = -0.000084
    @energy = 1.0
    @energy_max = 1.0
    @energy_fatigue_rate = -0.000193
    @energy_recovery_rate = 0.01
    @energy_usage_rate = -0.005
    @sanity = 1.0
    @sanity_rate = -0.0000069
  end

end
