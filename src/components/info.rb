class Info < Component

	attr_accessor :name, :description

	def initialize(name, description="")

		super()

		@name = name
		@description = description

	end

end