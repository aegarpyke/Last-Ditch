class Door < Component

	attr_accessor :open, :locked

	def initialize
		super()
		@open = false
		@locked = false
	end

end
