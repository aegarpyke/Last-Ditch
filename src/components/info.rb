class Info < Component

	attr_accessor :name, :occupation, :desc

	def initialize(name='', desc='', occupation='Unemployed')

		super()

		@name = name
    @desc = desc
		@occupation = occupation

	end

end