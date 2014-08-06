class Position < Component

	attr_accessor :x, :y, :px, :py

	def initialize(x, y)
		super()
		@x, @y = x, y
		@px, @py = x, y
	end

end

