class AISystem < System

	def initialize(mgr)

		@mgr = mgr
		@tick = 0

	end


	def update

		if @tick < 80

			@tick += 1

		else

			@tick = 0

			entities = @mgr.entities_with(AI)
			entities.each do |entity|

				vel = @mgr.comp(entity, Velocity)

				check = Random.rand
				if check < 1
					ang_spd = Random.rand(-vel.max_ang_spd..vel.max_ang_spd)
					vel.ang_spd = ang_spd
					vel.spd = vel.max_spd
				else
					vel.spd = 0
					vel.ang_spd = 0
				end

			end
			
		end

	end

end