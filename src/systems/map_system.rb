class MapSystem < System

	attr_accessor :width, :height
	attr_accessor :cam, :items, :doors, :focus, :atlas
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
		@rooms, @items, @doors = [], [], []
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

			item_id = @mgr.create_basic_entity

			condition, quality = Random.rand(0.2..1.0), Random.rand(0.1..0.9)

			item = @mgr.add_component(item_id, Item.new(quality, condition))
			render = @mgr.add_component(item_id, Render.new(''))
			size = @mgr.add_component(item_id, Size.new(0, 0))
			@mgr.add_component(item_id, Position.new(x, y))
			@mgr.add_component(item_id, Rotation.new(Random.rand(360)))

			check = Random.rand
			if check < 0.23
				
				render.region_name = 'canteen1_empty'
				render.region = @atlas.find_region('canteen1_empty')
				size.width = render.width * C::WTB
				size.height =render.height * C::WTB
				item.weight = 0.5
				item.base_value = 0.03

				@mgr.add_component(item_id, Type.new('canteen1_empty'))
				@mgr.add_component(item_id, Info.new(
					'Canteen, empty',
					"This is an empty canteen that can be used to carry "\
					"non-corrosive liquids."))
				
			elsif check < 0.32

				render.region_name = 'canister1_waste'
				render.region = @atlas.find_region('canister1_waste')
				size.width = render.width * C::WTB
				size.height =render.height * C::WTB
				item.weight = 1.1
				item.base_value = 0.08

				@mgr.add_component(item_id, Type.new('canister1_waste'))
				@mgr.add_component(item_id, Info.new(
					'Canister, waste',
					"This canister can be used to store corrosive "\
					"or toxix materials."))

			elsif check < 0.42

				render.region_name = 'canteen1_water'
				render.region = @atlas.find_region('canteen1_water')
				size.width = render.width * C::WTB
				size.height =render.height * C::WTB
				item.weight = 1.1
				item.base_value = 0.08

				@mgr.add_component(item_id, Type.new('canteen1_water'))
				@mgr.add_component(item_id, Info.new(
					'Canteen, water',
					"This is a canteen filled with clean drinking water."))

			elsif check < 0.56

				render.region_name = 'rations1_empty'
				render.region = @atlas.find_region('rations1_empty')
				size.width = render.width * C::WTB
				size.height = render.height * C::WTB
				item.weight = 0.6
				item.base_value = 0.12

				@mgr.add_component(item_id, Type.new('rations1_empty'))
				@mgr.add_component(item_id, Info.new(
					'Rations, empty',
					"This is one serving of prepared rations."))

			elsif check < 0.69

				render.region_name = 'handgun1'
				render.region = @atlas.find_region('handgun1')
				size.width = render.width * C::WTB
				size.height = render.height * C::WTB
				item.weight = 0.6
				item.base_value = 0.34

				@mgr.add_component(item_id, Type.new('handgun1'))
				@mgr.add_component(item_id, Info.new(
					'Handgun 1',
					"A basic handgun with limited sighting."))

			elsif check < 0.88

				render.region_name = 'overgrowth1'
				render.region = @atlas.find_region('overgrowth1')
				size.width = render.width * C::WTB
				size.height = render.height * C::WTB
				item.weight = 0.75
				item.base_value = 0.01

				@mgr.add_component(item_id, Type.new('overgrowth1'))
				@mgr.add_component(item_id, Info.new(
					'Overgrowth 1',
					"The base root of some overgrowth."))

				8.times do

					xx, yy = 0, 0
					sub_item_id = @mgr.create_basic_entity

					loop do
						xx = Random.rand(x - 1.2..x + 1.2)
						yy = Random.rand(y - 1.2..y + 1.2)
						
						break if !@solid[xx.to_i][yy.to_i]
					end

					sub_render = Render.new('')
					sub_size = Size.new(0, 0)
					sub_render.region_name = 'ruffage1'
					sub_render.region = @atlas.find_region('ruffage1')
					sub_size.width = sub_render.width * C::WTB
					sub_size.height = sub_render.height * C::WTB


					sub_quality, sub_dur = Random.rand(0.2..0.9), Random.rand(0.1..0.9)

					@mgr.add_component(sub_item_id, Position.new(xx, yy))
					@mgr.add_component(sub_item_id, Rotation.new(Random.rand(360)))
					sub_item = @mgr.add_component(sub_item_id, Item.new(sub_quality, sub_dur, 0.2, 0.1))
					@mgr.add_component(sub_item_id, sub_render)
					@mgr.add_component(sub_item_id, sub_size)
					@mgr.add_component(sub_item_id, Type.new('ruffage1'))
					@mgr.add_component(sub_item_id, Info.new(
						'Ruffage 1',
						"These are stray twigs and leaves from some "\
						"overgrowth."))

					sub_item.weight = 0.1
					sub_item.base_value = 0.001

					@items << sub_item_id

				end

			else

				render.region_name = 'scrap1'
				render.region = @atlas.find_region('scrap1')
				size.width = render.width * C::WTB
				size.height =render.height * C::WTB
				item.weight = 0.9
				item.base_value = 0.09

				@mgr.add_component(item_id, Type.new('scrap1'))
				@mgr.add_component(item_id, Info.new(
					'Scrap',
					"This is a piece of scrap material containing "\
					"pieces of metal and plastic."))

			end

			@items << item_id

		end

	end


	def generate_doors

		@rooms.each do |room|

			x = Random.rand(room.x1 + 1...room.x2 - 2)

			if Random.rand(2) == 0
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

			@mgr.add_component(door_id, render)
			@mgr.add_component(door_id, Position.new(x + w/2, y + h/2))
			@mgr.add_component(door_id, Size.new(w, h))
			@mgr.add_component(door_id, Rotation.new(rot))
			@mgr.add_component(door_id, Collision.new)
			@mgr.add_component(door_id, Type.new('door1'))
			@mgr.add_component(door_id, Door.new)

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
			
			@mgr.add_component(door_id, Render.new(
				'door1', 
				@atlas.find_region('door1')))

			w = render.width * C::WTB
			h = render.height * C::WTB

			@mgr.add_component(door_id, Position.new(x + h/2, y + w/2))
			@mgr.add_component(door_id, Size.new(w, h))
			@mgr.add_component(door_id, Rotation.new(rot))
			@mgr.add_component(door_id, Collision.new)
			@mgr.add_component(door_id, Type.new('door1'))
			@mgr.add_component(door_id, Door.new)

			@doors << door_id

		end

	end
	

	def get_item(x, y)

		@mgr.render.nearby_entities.each do |entity|

			if @items.include?(entity)

				pos = @mgr.comp(entity, Position)
				render = @mgr.comp(entity, Render)
				rot = @mgr.comp(entity, Rotation)

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

		nil

	end


	def remove_item(item_id)

		pos = @mgr.comp(item_id, Position)
		render = @mgr.comp(item_id, Render)

		@mgr.remove_component(item_id, pos)
		@mgr.remove_component(item_id, render)

		@items.delete(item_id)
		@mgr.inventory.update_slots = true

	end


	def get_door(x, y)

		@mgr.render.nearby_entities.each do |entity|

			if @doors.include?(entity)

				pos = @mgr.comp(entity, Position)
				render = @mgr.comp(entity, Render)
				size = @mgr.comp(entity, Size)
				rot = @mgr.comp(entity, Rotation)

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

		pos = @mgr.comp(door_id, Position)
		rot = @mgr.comp(door_id, Rotation)
		render = @mgr.comp(door_id, Render)
		size = @mgr.comp(door_id, Size)
		col = @mgr.comp(door_id, Collision)

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

			@mgr.add_component(
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