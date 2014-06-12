class PhysicsSystem < System

	attr_accessor :world, :player_body, :bodies

	def initialize(mgr, player, map)

		@mgr = mgr
		@map = map
		@bodies = []
		@player = player
		@gravity = Vector2.new(0.0, 0.0)
		@world = World.new(@gravity, false)
		@world.auto_clear_forces = false

		generate_entity_bodies
		generate_tile_bodies
		generate_door_bodies

	end


	def generate_entity_bodies

		entities = @mgr.get_all_entities_with_components([Animation, Collision])
		entities.each do |entity|

			pos = @mgr.get_component(entity, Position)
			anim = @mgr.get_component(entity, Animation)
			col = @mgr.get_component(entity, Collision)

			w = anim.width * C::WTB
			h = anim.height * C::WTB

			body_def = BodyDef.new
			body_def.type = BodyType::DynamicBody
			body_def.linearDamping = 20.0
			body_def.position.set(pos.x + w/2, pos.y + h/2)

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

			col.body = @world.create_body(body_def)
			col.body.create_fixture(fixture_def)
			col.body.fixed_rotation = true
			col.body.user_data = entity

			if entity == @player
				@player_body = col.body
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

			pos = @mgr.get_component(door, Position)
			rot = @mgr.get_component(door, Rotation)
			render = @mgr.get_component(door, Render)
			col = @mgr.get_component(door, Collision)

			w = render.width * C::WTB
			h = render.height * C::WTB

			col.body = create_body(
				pos.x, pos.y,
				w, h, false, rot.angle)

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

		entities = @mgr.get_all_entities_with(Velocity)
		entities.each do |entity|

			pos = @mgr.get_component(entity, Position)
			vel = @mgr.get_component(entity, Velocity)
			rot = @mgr.get_component(entity, Rotation)
			col = @mgr.get_component(entity, Collision)

			pos.px = pos.x
			pos.py = pos.y
			rot.p_angle = rot.angle

			if vel.spd != 0

				vel_vec = Vector2.new(
					vel.spd * rot.x, 
					vel.spd * rot.y)

				col.body.apply_linear_impulse(
					vel_vec, 
					col.body.world_center, 
					true)

			end

			if vel.ang_spd != 0
				rot.rotate(vel.ang_spd)
			end

		end

		@world.step(C::BOX_STEP, C::BOX_VEL_ITER, C::BOX_POS_ITER)

		entities = @mgr.get_all_entities_with(Velocity)
		entities.each do |entity|

			pos = @mgr.get_component(entity, Position)
			col = @mgr.get_component(entity, Collision)

			pos.x = col.body.position.x
			pos.y = col.body.position.y

		end

	end


	def interpolate(alpha)

		pos = @mgr.get_component(@player, Position)
		rot = @mgr.get_component(@player, Rotation)
		col = @mgr.get_component(@player, Collision)

		x = alpha * pos.px + (1 - alpha) * pos.x
		y = alpha * pos.py + (1 - alpha) * pos.y
		angle = alpha * rot.p_angle + (1 - alpha) * rot.angle

		col.body.set_transform(x, y, 0)

		pos.x = col.body.position.x
		pos.y = col.body.position.y
		rot.angle = angle

	end


	def dispose

		@world.dispose

	end

end