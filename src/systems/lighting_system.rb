class LightingSystem < System

	Light.set_contact_filter(C::BIT_LIGHT, 0, C::BIT_WALL)

	def initialize(mgr, world, body)

		@mgr = mgr

		@handler = RayHandler.new(world)

		@central_light = PointLight.new(@handler, 400)
		@central_light.soft = true
		@central_light.softness_length = 1.7
		@central_light.color = Color.new(0.18, 0.18, 0.18, 1.0)
		@central_light.distance = 32
		@central_light.attach_to_body(body, 0.0, 0.0)

	end


	def update(matrix)

		@handler.set_combined_matrix(matrix.scl(C::BTW))

		@handler.update_and_render

	end


	def dispose

	end

end