class Position < Component

	attr_accessor :x, :y

	def initialize(x, y)

		super()
		@x, @y = x, y

	end

end

