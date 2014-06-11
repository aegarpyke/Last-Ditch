class StatusSystem < System

	def initialize(mgr)
		super()
		@mgr = mgr

	end


	def update

		entities = @mgr.get_all_entities_with_components([Needs, Velocity])
		entities.each do |entity|

			vel_comp = @mgr.get_component(entity, Velocity)
			need_comp = @mgr.get_component(entity, Needs)

			need_comp.hunger += need_comp.hunger_rate * C::BOX_STEP
			need_comp.hunger = [0, need_comp.hunger, 1].sort[1]
			need_comp.thirst += need_comp.thirst_rate * C::BOX_STEP
			need_comp.thirst = [0, need_comp.thirst, 1].sort[1]
			
			if vel_comp.spd > 0
				need_comp.energy += need_comp.energy_usage_rate * C::BOX_STEP
			elsif vel_comp.spd < 0
				need_comp.energy += need_comp.energy_usage_rate * C::BOX_STEP * 0.4
			else
				need_comp.energy += need_comp.energy_recovery_rate * C::BOX_STEP
			end
			
			need_comp.energy_max += C::FATIGUE_RATE * C::BOX_STEP

			need_comp.energy_max = 0 if need_comp.energy_max < 0

			need_comp.energy = [0, need_comp.energy, need_comp.energy_max].sort[1]
			need_comp.sanity += need_comp.sanity_rate * C::BOX_STEP
			need_comp.sanity = [0, need_comp.sanity, 1].sort[1]

		end

	end


	def dispose


	end

end