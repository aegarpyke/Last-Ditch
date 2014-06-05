class Velocity < Component

	attr_accessor :spd, :ang_spd

	def initialize(spd, ang_spd)

		super()
		@spd = spd
		@ang_spd = ang_spd

	end

end