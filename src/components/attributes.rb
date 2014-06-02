class Attributes < Component

	attr_accessor :strength, :dexterity, :agility, :endurance, :intelligence

	def initialize

		super()
		@strength = 10.0
		@dexterity = 10.0
		@agility = 10.0
		@endurance = 10.0
		@intelligence = 10.0

	end

end