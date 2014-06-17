class Info < Component

	attr_accessor :name, :occupation, :desc

	def initialize(name, desc="", occupation="Unemployed")

		super()

		@name = name
		@occupation = occupation
		@desc = desc

	end

end