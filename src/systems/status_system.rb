class StatusSystem < System

	def initialize(mgr)

		super()
		@mgr = mgr

	end


	def update

		unless @mgr.paused

			entities = @mgr.entities_with_components([Needs, Velocity])
			entities.each do |entity|

				vel = @mgr.comp(entity, Velocity)
				needs = @mgr.comp(entity, Needs)

				gd = @mgr.time.game_delta

				needs.hunger += needs.hunger_rate * gd
				needs.hunger = [0, needs.hunger, 1].sort[1]
				
				needs.thirst += needs.thirst_rate * gd
				needs.thirst = [0, needs.thirst, 1].sort[1]
				
				if vel.spd > 0
					needs.energy += needs.energy_usage_rate * gd
				elsif vel.spd < 0
					needs.energy += needs.energy_usage_rate * gd * 0.4
				else
					needs.energy += needs.energy_recovery_rate * gd
				end
				
				needs.energy_max += needs.energy_fatigue_rate * gd
				needs.energy_max = 0 if needs.energy_max < 0
				needs.energy = [0, needs.energy, needs.energy_max].sort[1]

				needs.sanity += needs.sanity_rate * gd
				needs.sanity = [0, needs.sanity, 1].sort[1]

			end

		end

	end


	def dispose


	end

end