class Skills < Component

	attr_accessor :electronics, :computers, :mechanical

	def initialize

		super()
		@electronics = 10.0
		@computers = 10.0
    @mechanical = 10.0

	end

end