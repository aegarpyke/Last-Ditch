class Needs < Component

	attr_accessor :hunger, :thirst, :energy, :sanity
	attr_accessor :hunger_rate, :thirst_rate, :energy_rate, :sanity_rate

	def initialize
	
		super()
		@hunger = 1.0
		@hunger_rate = -0.006
		@thirst = 1.0
		@thirst_rate = -0.01
		@energy = 1.0
		@energy_rate = -0.02
		@sanity = 1.0
		@sanity_rate = -0.001

	end

end