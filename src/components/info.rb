class Info < Component

	attr_accessor :name, :occupation, :description

	def initialize(name, description="", occupation="Unemployed")

		super()

		@name = name
		@occupation = occupation
		@description = description

	end

end