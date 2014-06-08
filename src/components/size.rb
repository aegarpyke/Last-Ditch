class Size < Component

	attr_accessor :width, :height

	def initialize(width, height)

		super()
		@width = width
		@height = height

	end

end