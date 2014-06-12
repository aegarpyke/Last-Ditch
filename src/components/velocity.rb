class Velocity < Component

	attr_accessor :spd, :ang_spd, :max_spd, :max_ang_spd

	def initialize(spd, ang_spd, max_spd, max_ang_spd)

		super()
		
		@spd = spd
		@max_spd = max_spd
		@ang_spd = ang_spd
		@max_ang_spd = max_ang_spd

	end

end