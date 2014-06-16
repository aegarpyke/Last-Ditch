class SoundSystem < System

	def initialize(mgr, map, render, world)

		super()
		@mgr = mgr
		@map = map
		@render = render
		@world = world
		@player_pos = @map.focus

	end


	def update

		# vec1 = Vector2.new(@player_pos.x, @player_pos.y)

		# @render.nearby_entities.each do |entity|

		# 	if @mgr.comp_type?(entity, AI)
			
		# 		pos = @mgr.comp(entity, Position)

		# 		vec2 = Vector2.new(pos.x, pos.y)

		# 		callback = Class.new(RayCastCallbackImpl) do
					
		# 			def report_ray_fixture(fixture, point, normal, fraction)

		# 			end

		# 		end.new

		# 		@world.ray_cast(callback, vec1, vec2)

		# 	end

		# end

	end


	def render


	end

end