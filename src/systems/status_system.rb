class StatusSystem < System

	def initialize(mgr)
		super()
		@mgr = mgr

	end


	def tick(delta)

		entities = @mgr.get_all_entities_with(Needs)
		entities.each do |entity|

			gd = @mgr.time.game_delta

			need_comp = @mgr.get_component(entity, Needs)

			need_comp.hunger += need_comp.hunger_rate * gd
			need_comp.hunger = [0, need_comp.hunger, 1].sort[1]
			need_comp.thirst += need_comp.thirst_rate * gd
			need_comp.thirst = [0, need_comp.thirst, 1].sort[1]
			need_comp.energy += need_comp.energy_rate * gd
			need_comp.energy = [0, need_comp.energy, 1].sort[1]
			need_comp.sanity += need_comp.sanity_rate * gd
			need_comp.sanity = [0, need_comp.sanity, 1].sort[1]

		end

	end

end