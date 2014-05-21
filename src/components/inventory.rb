class Inventory < Component

	attr_accessor :items

	def initialize(size)

		super()
		@items = Array.new(size)

	end

end
