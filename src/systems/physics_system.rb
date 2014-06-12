class PhysicsSystem < System

	attr_accessor :world, :player_body, :bodies

	def initialize(mgr, player, map)

		@mgr = mgr
		@map = map
		@bodies = []
		@player = player
		@gravity = Vector2.new(0.0, 0.0)
		@world = World.new(@gravity, true)
		@world.auto_clear_forces = false

		generate_entity_bodies
		generate_tile_bodies
		generate_door_bodies

	end


	def generate_entity_bodies

		entities = @mgr.get_all_entities_with_components([Animation, Collision])
		entities.each do |entity|

			pos_comp = @mgr.get_component(entity, Position)
			anim_comp = @mgr.get_component(entity, Animation)
			col_comp = @mgr.get_component(entity, Collision)

			w = anim_comp.width * C::WTB
			h = anim_comp.height * C::WTB

			puts w, h

			body_def = BodyDef.new
			body_def.type = BodyType::DynamicBody
			body_def.linearDamping = 20.0
			body_def.position.set(pos_comp.x + w/2, pos_comp.y + h/2)

			shape = CircleShape.new
			shape.radius = w/2 - 0.01

			fixture_def = FixtureDef.new
			fixture_def.shape = shape
			fixture_def.friction = 0.2
			fixture_def.density = 1.0

			if entity == @player
				fixture_def.filter.categoryBits = C::BIT_PLAYER
			else
				fixture_def.filter.categoryBits = C::BIT_ENTITY
			end

			col_comp.body = @world.create_body(body_def)
			col_comp.body.create_fixture(fixture_def)
			col_comp.body.fixed_rotation = true
			col_comp.body.user_data = entity

			if entity == @player
				@player_body = col_comp.body
			end

		end

	end


	def generate_tile_bodies

		for x in 0...@map.width
			for y in 0...@map.height

				if @map.solid[x][y]
					
					body_def = BodyDef.new
					body_def.position.set(x + 0.5, y + 0.5)

					shape = PolygonShape.new
					shape.set_as_box(0.5, 0.5)

					fixture_def = FixtureDef.new
					fixture_def.shape = shape

					if @map.sight[x][y]
						fixture_def.filter.categoryBits = C::BIT_WINDOW
					else
						fixture_def.filter.categoryBits = C::BIT_WALL
					end

					body = @world.create_body(body_def)
					body.create_fixture(fixture_def)
					body.user_data = [x, y]

				end

			end
			
		end

	end


	def generate_door_bodies

		@map.doors.each do |door|

			pos_comp = @mgr.get_component(door, Position)
			rot_comp = @mgr.get_component(door, Rotation)
			render_comp = @mgr.get_component(door, Render)
			col_comp = @mgr.get_component(door, Collision)

			w = render_comp.width * C::WTB
			h = render_comp.height * C::WTB

			col_comp.body = create_body(
				pos_comp.x, pos_comp.y,
				w, h, false, rot_comp.angle)

		end

	end


	def create_body(x, y, width, height, sight, angle)

		body_def = BodyDef.new
		body_def.position.set(x, y)

		shape = PolygonShape.new
		shape.set_as_box(width/2, height/2)

		fixture_def = FixtureDef.new
		fixture_def.shape = shape

		if sight
			fixture_def.filter.categoryBits = C::BIT_WINDOW
		else
			fixture_def.filter.categoryBits = C::BIT_WALL
		end

		body = @world.create_body(body_def)
		body.create_fixture(fixture_def)
		body.set_transform(x, y, angle * Math::PI / 180)
		
		shape.dispose

		body

	end


	def remove_body(body)

		@world.destroy_body(body)

	end


	def update

		unless @mgr.paused

			entities = @mgr.get_all_entities_with(Velocity)
			entities.each do |entity|

				pos_comp = @mgr.get_component(entity, Position)
				vel_comp = @mgr.get_component(entity, Velocity)
				rot_comp = @mgr.get_component(entity, Rotation)
				col_comp = @mgr.get_component(entity, Collision)

				pos_comp.px = pos_comp.x
				pos_comp.py = pos_comp.y
				rot_comp.p_angle = rot_comp.angle

				if vel_comp.spd != 0

					vel_vec = Vector2.new(
						vel_comp.spd * rot_comp.x, 
						vel_comp.spd * rot_comp.y)

					col_comp.body.apply_linear_impulse(
						vel_vec, 
						col_comp.body.world_center, 
						true)

					pos_comp.x = col_comp.body.position.x
					pos_comp.y = col_comp.body.position.y

				end

				if vel_comp.ang_spd != 0
					rot_comp.rotate(vel_comp.ang_spd)
				end

			end

			@world.step(C::BOX_STEP, C::BOX_VEL_ITER, C::BOX_POS_ITER)
			
		end

	end


	def interpolate(alpha)

		pos_comp = @mgr.get_component(@player, Position)
		rot_comp = @mgr.get_component(@player, Rotation)
		col_comp = @mgr.get_component(@player, Collision)

		x = alpha * pos_comp.x + (1 - alpha) * pos_comp.px
		y = alpha * pos_comp.y + (1 - alpha) * pos_comp.py
		angle = alpha * rot_comp.angle + (1 - alpha) * rot_comp.p_angle

		col_comp.body.set_transform(x, y, angle)

	end


	def dispose

		@world.dispose

	end

end