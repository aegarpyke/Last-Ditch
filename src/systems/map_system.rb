class MapSystem < System

	attr_accessor :width, :height
	attr_accessor :cam, :items, :doors, :workstations, :focus, :atlas
	attr_accessor :tiles, :solid, :sight, :rot

	def initialize(mgr, player, atlas)

		super()
		@mgr = mgr
		@atlas = atlas
		@cam = OrthographicCamera.new
		@cam.set_to_ortho(false, C::WIDTH, C::HEIGHT)
		@width, @height = C::MAP_WIDTH, C::MAP_HEIGHT
		@focus = @mgr.comp(player, Position)
		
		@iterations = 120
		@rooms, @items, @doors, @workstations = [], [], [], []
		@num_of_rooms, @num_of_items = 200, 1200

		@solid = Array.new(@width) {|i| Array.new(@height) {|i| false }}
		@sight = Array.new(@width) {|i| Array.new(@height) {|i| true }}
		@rot   = Array.new(@width) {|i| Array.new(@height) {|i| 0.0}}
		@tiles = Array.new(@width) {|i| Array.new(@height) {|i| @atlas.find_region('floor1')}}

		for x in 0...@width
			for y in 0...@height

				if x == 0 || y == 0 || x == @width-1 || y == @height-1
					
					@solid[x][y] = true
					@sight[x][y] = true
					@tiles[x][y] = @atlas.find_region('empty')

				end

			end
		end

		generate_rooms
		generate_items
		generate_doors
		generate_workstations

		update

	end


	def generate_rooms
		
		x, y = 0, 0
		@master = Room.new(10, 10, C::MAP_WIDTH - 10, C::MAP_HEIGHT - 10)

		for i in 0...@num_of_rooms

		  x = Random.rand(@master.x1...@master.x2)
		  y = Random.rand(@master.y1...@master.y2)

		  @rooms << Room.new(x, y, 1, 1)
		
		end

		for i in 0...@iterations
			@rooms.each do |room|
				expand(room)
			end
		end

		degenerate_rooms = []
		@rooms.each do |room|

			if room.width < 5 || room.height < 5

				degenerate_rooms << room

			else
				
				for x in room.x1...room.x2
					for y in room.y1...room.y2

						if x == room.x1 || x == room.x2-1

							@solid[x][y] = true
							@sight[x][y] = false
							@rot[x][y]   = 0.0
							@tiles[x][y] = @atlas.find_region('wall1')

						elsif y == room.y1 || y == room.y2-1

							@solid[x][y] = true
							@sight[x][y] = false
							@rot[x][y]   = 0.0
							@tiles[x][y] = @atlas.find_region('wall1')

						else

							@solid[x][y] = false
							@sight[x][y] = true
							@rot[x][y]   = 0.0
							@tiles[x][y] = @atlas.find_region('floor2')

						end

					end
				end

			end

		end

		@rooms -= degenerate_rooms

	end


	def generate_items

		x, y = 0, 0

		for i in 0...@num_of_items

			loop do
				x = Random.rand(10.0...@width-10)
				y = Random.rand(10.0...@height-10)
				
				break if !@solid[x.to_i][y.to_i]
			end

			choice = C::ITEMS.sample

			item_id = @mgr.inventory.create_item(choice, x, y)

			@items << item_id

			if choice == 'overgrowth1'

				8.times do

					xx, yy = 0, 0

					loop do
						xx = Random.rand(x - 1.2..x + 1.2)
						yy = Random.rand(y - 1.2..y + 1.2)
						
						break if !@solid[xx.to_i][yy.to_i]
					end

					item_id = @mgr.inventory.create_item('ruffage1', xx, yy)
					
					@items << item_id 

				end

			end

		end

	end


	def generate_doors

		@rooms.each do |room|

			x = Random.rand(room.x1 + 1...room.x2 - 2)

			if Random.rand < 0.5
				y = room.y1
				rot = 0
			else
				y = room.y2 - 1
				rot = 180
			end

			@solid[x][y] = false
			@sight[x][y] = true
			@rot[x][y]   = 0.0
			@tiles[x][y] = @atlas.find_region('floor2')

			@solid[x+1][y] = false
			@sight[x+1][y] = true
			@rot[x+1][y]   = 0.0
			@tiles[x+1][y] = @atlas.find_region('floor2')

			door_id = @mgr.create_basic_entity

			render = Render.new('door1', @atlas.find_region('door1'))
			w = render.width * C::WTB
			h = render.height * C::WTB

			@mgr.add_comp(door_id, render)
			@mgr.add_comp(door_id, Position.new(x + w/2, y + h/2))
			@mgr.add_comp(door_id, Size.new(w, h))
			@mgr.add_comp(door_id, Rotation.new(rot))
			@mgr.add_comp(door_id, Collision.new)
			@mgr.add_comp(door_id, Type.new('door1'))
			@mgr.add_comp(door_id, Door.new)

			@doors << door_id

			y = Random.rand(room.y1 + 1...room.y2 - 2)

			if Random.rand(2) == 0
				x = room.x1
				rot = 90
			else
				x = room.x2 - 1
				rot = -90
			end

			@solid[x][y] = false
			@sight[x][y] = true
			@rot[x][y]   = 0.0
			@tiles[x][y] = @atlas.find_region('floor2')

			@solid[x][y+1] = false
			@sight[x][y+1] = true
			@rot[x][y+1]   = 0.0
			@tiles[x][y+1] = @atlas.find_region('floor2')

			door_id = @mgr.create_basic_entity
			
			@mgr.add_comp(door_id, Render.new(
				'door1', 
				@atlas.find_region('door1')))

			w = render.width * C::WTB
			h = render.height * C::WTB

			@mgr.add_comp(door_id, Position.new(x + h/2, y + w/2))
			@mgr.add_comp(door_id, Size.new(w, h))
			@mgr.add_comp(door_id, Rotation.new(rot))
			@mgr.add_comp(door_id, Collision.new)
			@mgr.add_comp(door_id, Type.new('door1'))
			@mgr.add_comp(door_id, Door.new)

			@doors << door_id

		end

	end


	def generate_workstations

		@rooms.each do |room|

			if room.x1 + 2 < room.x2 - 4 && room.y1 + 2 < room.y2 - 4

				workstation_id = @mgr.create_basic_entity

				rot = [0, 90, 180, 270].sample
				workstation_type = ['incinerator', 'programming_desk'].sample
				render = Render.new(
					workstation_type, @atlas.find_region(workstation_type))
				
				w = render.width * C::WTB
				h = render.height * C::WTB
				x = Random.rand(room.x1 + 2...room.x2 - 4)
				y = Random.rand(room.y1 + 2...room.y2 - 4)
				
				if [0, 180].include?(rot)
					@mgr.add_comp(workstation_id, Position.new(x + w/2, y + h/2))
				elsif [90, 270].include?(rot)
					@mgr.add_comp(workstation_id, Position.new(x + h/2, y + w/2))
				end

				@mgr.add_comp(workstation_id, render)
				@mgr.add_comp(workstation_id, Size.new(w, h))
				@mgr.add_comp(workstation_id, Rotation.new(rot))
				@mgr.add_comp(workstation_id, Collision.new)
				@mgr.add_comp(workstation_id, Type.new('workstation'))
				@mgr.add_comp(workstation_id, Workstation.new(workstation_type))

				@workstations << workstation_id

			end

		end

	end
	

	def get_item(x, y)

		@mgr.render.nearby_entities.each do |entity|

			pos = @mgr.comp(entity, Position)
			dist_sqr = (pos.x - x)**2 + (pos.y - y)**2
			
			if dist_sqr < 1.4

				if @items.include?(entity)
					
					rot    = @mgr.comp(entity, Rotation)
					render = @mgr.comp(entity, Render)

					# Transform coordinates to axis-aligned frame
					c = Math.cos(-rot.angle * Math::PI/180)
					s = Math.sin(-rot.angle * Math::PI/180)
					rot_x = pos.x + c * (x - pos.x) - s * (y - pos.y)
					rot_y = pos.y + s * (x - pos.x) + c * (y - pos.y)

					left   = pos.x - render.width * C::WTB / 2
					right  = pos.x + render.width * C::WTB / 2
					top    = pos.y - render.height * C::WTB / 2
					bottom = pos.y + render.height * C::WTB / 2

					if left <= rot_x && rot_x <= right && top <= rot_y && rot_y <= bottom
						return entity
					end

				end

			end

		end

		nil

	end


	def remove_item(item_id)

		pos    = @mgr.comp(item_id, Position)
		render = @mgr.comp(item_id, Render)

		@mgr.remove_component(item_id, pos)
		@mgr.remove_component(item_id, render)

		@items.delete(item_id)
		@mgr.inventory.update_slots = true

	end


	def get_door(x, y)

		@mgr.render.nearby_entities.each do |entity|

			if @doors.include?(entity)

				pos    = @mgr.comp(entity, Position)
				render = @mgr.comp(entity, Render)
				size   = @mgr.comp(entity, Size)
				rot    = @mgr.comp(entity, Rotation)

				# Transform coordinates to axis-aligned frame
				c = Math.cos(-rot.angle * Math::PI/180)
				s = Math.sin(-rot.angle * Math::PI/180)
				rot_x = pos.x + c * (x - pos.x) - s * (y - pos.y)
				rot_y = pos.y + s * (x - pos.x) + c * (y - pos.y)

				left   = pos.x - size.width / 2
				right  = pos.x + size.width / 2
				top    = pos.y - size.height / 2
				bottom = pos.y + size.height / 2

				if left <= rot_x && rot_x <= right && top <= rot_y && rot_y <= bottom
					return entity
				end

			end

		end

		nil

	end


	def get_near_door(x, y)

		@mgr.render.nearby_entities.each do |entity|

			if @doors.include?(entity)
				
				pos = @mgr.comp(entity, Position)
				dist_sqr = (pos.x - x)**2 + (pos.y - y)**2

				if dist_sqr < 2.6
					return entity
				end

			end

		end

		nil

	end


	def change_door(door_id, open)

		pos    = @mgr.comp(door_id, Position)
		rot    = @mgr.comp(door_id, Rotation)
		render = @mgr.comp(door_id, Render)
		size   = @mgr.comp(door_id, Size)
		col    = @mgr.comp(door_id, Collision)

		if open

			render = @mgr.comp(door_id, Render)
			@mgr.remove_component(door_id, render)
			@mgr.physics.remove_body(col.body)

		else

			type = @mgr.comp(door_id, Type).type

			body = @mgr.physics.create_body(
				pos.x, pos.y, 
				size.width, size.height, 
				false, rot.angle)

			@mgr.add_comp(
				door_id, 
				Render.new(type, @atlas.find_region(type)))
		
		end

	end


	def get_near_item(x, y)

		@mgr.render.nearby_entities.each do |entity|

			if @items.include?(entity)
				
				pos = @mgr.comp(entity, Position)
				dist_sqr = (pos.x - x)**2 + (pos.y - y)**2

				if dist_sqr < 1.4
					return entity
				end

			end

		end

		nil

	end


	def expand(test_room)

		direction = Random.rand(4)

		case direction
			when 0
				test_room.x1 -= 2 if test_room.x1 - 2 > @master.x1
			when 1
				test_room.y1 -= 2 if test_room.y1 - 2 > @master.y1
			when 2
				test_room.x2 += 2 if test_room.x2 + 2 < @master.x2
			when 3
				test_room.y2 += 2 if test_room.y2 + 2 < @master.y2
		end

		check = false
		@rooms.each do |room|

			next if room == test_room

			if intersects(room, test_room)

				check = true
				break

			end

		end

		fix = check ? 2 : 1

		case direction
			when 0
				test_room.x1 += fix
			when 1
				test_room.y1 += fix
			when 2
				test_room.x2 -= fix
			when 3
				test_room.y2 -= fix
		end

	end


	def intersects(r1, r2)
		!(r1.x2 < r2.x1 || r2.x2 < r1.x1 || r1.y2 < r2.y1 || r2.y2 < r1.y1)
	end


	def update

		@start_x = [@focus.x - 13, 0].max.to_i
		@start_y = [@focus.y - 10, 0].max.to_i
		@end_x   = [@focus.x + 13, C::MAP_WIDTH-1].min.to_i
		@end_y   = [@focus.y + 10, C::MAP_HEIGHT-1].min.to_i

		@cam.position.set(@focus.x * C::BTW, @focus.y * C::BTW, 0)
		@cam.update
		
	end


	def render(batch)

		for x in @start_x..@end_x
			for y in @start_y..@end_y

				batch.draw(
					@tiles[x][y],
					x * C::BTW, y * C::BTW,
					C::BTW/2, C::BTW/2, 
					C::BTW, C::BTW,
					1, 1,
					@rot[x][y])

			end
		end

	end


	def dispose


	end

end