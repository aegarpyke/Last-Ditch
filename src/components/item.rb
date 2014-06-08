class Item < Component

	attr_accessor :durability, :quality

	def initialize(durability=1, quality=0.5)
		super()

		@durability = durability
		@quality = quality

	end

end