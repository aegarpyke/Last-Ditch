class Needs < Component

	attr_accessor :hunger, :thirst, :energy, :energy_max, :sanity
	attr_accessor :hunger_rate, :thirst_rate, :energy_recovery_rate, :energy_usage_rate, :sanity_rate

	def initialize
	
		super()
		@hunger = 1.0
		@hunger_rate = -0.0003
		@thirst = 1.0
		@thirst_rate = -0.0006
		@energy = 1.0
		@energy_max = 1.0
		@energy_recovery_rate = 0.01
		@energy_usage_rate = -0.005
		@sanity = 1.0
		@sanity_rate = -0.00001

	end

end