class PhysicsSystem < System

	DRAG = 0.91

	attr_accessor :world, :player_body

	def initialize(mgr, map)

		@mgr = mgr

		@gravity = Vector2.new(0.0, 0.0)

		@world = World.new(@gravity, true)

		entities = @mgr.get_all_entities_with(Collision)
		entities.each do |entity|

			pos_comp = @mgr.get_component(entity, Position)
			col_comp = @mgr.get_component(entity, Collision)

			body_def = BodyDef.new
			body_def.type = BodyType::DynamicBody
			body_def.linearDamping = 20.0
			body_def.position.set(pos_comp.x + 0.5, pos_comp.y + 0.5)

			shape = CircleShape.new
			shape.radius = 0.49

			fixture_def = FixtureDef.new
			fixture_def.shape = shape
			fixture_def.friction = 0.2
			fixture_def.density = 1.0
			fixture_def.filter.categoryBits = C::BIT_PLAYER

			col_comp.body = @world.create_body(body_def)
			@player_body = col_comp.body

			col_comp.body.create_fixture(fixture_def)
			col_comp.body.fixed_rotation = true
			col_comp.body.user_data = entity

		end

		for x in 0...map.width
			for y in 0...map.height

				if map.solid[x][y]
					
					body_def = BodyDef.new
					body_def.position.set(x + 0.5, y + 0.5)

					shape = PolygonShape.new
					shape.set_as_box(0.5, 0.5)

					fixture_def = FixtureDef.new
					fixture_def.shape = shape

					if map.sight[x][y]
						fixture_def.filter.categoryBits = C::BIT_WINDOW
					else
						fixture_def.filter.categoryBits = C::BIT_WALL
					end

					body = @world.create_body(body_def)
					map.bodies << body

					body.create_fixture(fixture_def)
					body.user_data = [x, y]

				end

			end
			
		end

	end


	def update(delta)

		unless @mgr.paused

			entities = @mgr.get_all_entities_with_components([Velocity, Collision])
			entities.each do |entity|

				pos_comp = @mgr.get_component(entity, Position)
				vel_comp = @mgr.get_component(entity, Velocity)
				rot_comp = @mgr.get_component(entity, Rotation)
				col_comp = @mgr.get_component(entity, Collision)

				if vel_comp.spd != 0

					vel_vec = Vector2.new(
						delta * vel_comp.spd * rot_comp.x, 
						delta * vel_comp.spd * rot_comp.y)

					col_comp.body.apply_linear_impulse(
						vel_vec, 
						col_comp.body.world_center, 
						true)

				end

				rot_comp.rotate(vel_comp.ang_spd)

			end

			@world.step(C::BOX_STEP, C::BOX_VEL_ITER, C::BOX_POS_ITER)

		end

	end


	def dispose

		@world.dispose

	end

end