class Item < Component

	attr_accessor :durability, :quality, :weight, :base_value

	def initialize(quality=0.5, durability=1, weight=0.5, base_value=1)

		super()

		@weight = weight
		@quality = quality
		@durability = durability
		@base_value = base_value
		@value = @base_value * @quality * @durability

	end

	def value
		@value = @base_value * @quality * @durability
	end

end