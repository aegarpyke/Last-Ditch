class LightingSystem < System

	def initialize(mgr, world, body)

		@mgr = mgr
		@handler = RayHandler.new(world)

		RayHandler.isDiffuse = true
		Light.set_contact_filter(C::BIT_LIGHT, 0, C::BIT_WALL)
		
		@central_light = PointLight.new(@handler, 400)
		@central_light.soft = true
		@central_light.softness_length = 1.2
		@central_light.color = Color.new(0.80, 0.80, 0.80, 1.0)
		@central_light.distance = 1000
		@central_light.attach_to_body(body, 0.0, 0.0)

	end


	def update(matrix)

		@handler.set_combined_matrix(matrix.scl(C::BTW))
		@handler.update_and_render

	end


	def dispose

	end

end