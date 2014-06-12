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

			entities = @mgr.get_all_entities_with(AI)
			entities.each do |entity|

				vel_comp = @mgr.get_component(entity, Velocity)

				check = Random.rand
				if check < 1
					ang_spd = Random.rand(-vel_comp.max_ang_spd..vel_comp.max_ang_spd)
					vel_comp.ang_spd = ang_spd
					vel_comp.spd = vel_comp.max_spd
				else
					vel_comp.spd = 0
					vel_comp.ang_spd = 0
				end

			end
			
		end

	end

end