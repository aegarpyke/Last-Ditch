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
		@focus = @mgr.get_component(player, Position)
		
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

			item = @mgr.create_basic_entity

			dur, quality = Random.rand(0.2..1.0), Random.rand(0.1..0.9)

			item_comp = @mgr.add_component(item, Item.new(quality, dur))
			render_comp = @mgr.add_component(item, Render.new(''))
			size_comp = @mgr.add_component(item, Size.new(0, 0))
			@mgr.add_component(item, Position.new(x, y))
			@mgr.add_component(item, Rotation.new(Random.rand(360)))

			check = Random.rand
			if check < 0.23
				
				render_comp.region_name = 'canteen1'
				render_comp.region = @atlas.find_region('canteen1')
				size_comp.width = render_comp.width * C::WTB
				size_comp.height =render_comp.height * C::WTB
				item_comp.weight = 0.5
				item_comp.base_value = 0.5

				@mgr.add_component(item, Type.new('canteen1'))
				@mgr.add_component(item, Info.new(
					'Canteen 1',
					"This is a drinking canteen"))
				
			elsif check < 0.32

				render_comp.region_name = 'canister1'
				render_comp.region = @atlas.find_region('canister1')
				size_comp.width = render_comp.width * C::WTB
				size_comp.height =render_comp.height * C::WTB
				item_comp.weight = 1.1
				item_comp.base_value = 1.2

				@mgr.add_component(item, Type.new('canister1'))
				@mgr.add_component(item, Info.new(
					'Canister 1',
					"A sealed container"))

			elsif check < 0.56

				render_comp.region_name = 'rations1'
				render_comp.region = @atlas.find_region('rations1')
				size_comp.width = render_comp.width * C::WTB
				size_comp.height = render_comp.height * C::WTB
				item_comp.weight = 0.6
				item_comp.base_value = 0.9

				@mgr.add_component(item, Type.new('rations1'))
				@mgr.add_component(item, Info.new(
					'Rations 1',
					"This is rations container"))

			elsif check < 0.88

				render_comp.region_name = 'overgrowth1'
				render_comp.region = @atlas.find_region('overgrowth1')
				size_comp.width = render_comp.width * C::WTB
				size_comp.height = render_comp.height * C::WTB
				item_comp.weight = 0.75
				item_comp.base_value = 0.3

				@mgr.add_component(item, Type.new('overgrowth1'))
				@mgr.add_component(item, Info.new(
					'Overgrowth 1',
					"The root of some overgrowth"))

				8.times do

					xx, yy = 0, 0
					sub_item = @mgr.create_basic_entity

					loop do
						xx = Random.rand(x - 1.2..x + 1.2)
						yy = Random.rand(y - 1.2..y + 1.2)
						
						break if !@solid[xx.to_i][yy.to_i]
					end

					sub_render_comp = Render.new('')
					sub_size_comp = Size.new(0, 0)
					sub_render_comp.region_name = 'ruffage1'
					sub_render_comp.region = @atlas.find_region('ruffage1')
					sub_size_comp.width = sub_render_comp.width * C::WTB
					sub_size_comp.height = sub_render_comp.height * C::WTB

					sub_quality, sub_dur = Random.rand(0.2..0.9), Random.rand(0.1..0.9)

					@mgr.add_component(sub_item, Position.new(xx, yy))
					@mgr.add_component(sub_item, Rotation.new(Random.rand(360)))
					@mgr.add_component(sub_item, Item.new(sub_quality, sub_dur, 0.2, 0.1))
					@mgr.add_component(sub_item, sub_render_comp)
					@mgr.add_component(sub_item, sub_size_comp)
					@mgr.add_component(sub_item, Type.new('ruffage1'))
					@mgr.add_component(sub_item, Info.new(
						'Ruffage 1',
						"Stray vines and roots"))

					@items << sub_item

				end

			else

				render_comp.region_name = 'scrap1'
				render_comp.region = @atlas.find_region('scrap1')
				size_comp.width = render_comp.width * C::WTB
				size_comp.height =render_comp.height * C::WTB
				item_comp.weight = 0.9
				item_comp.base_value = 0.6

				@mgr.add_component(item, Type.new('scrap1'))
				@mgr.add_component(item, Info.new(
					'Scrap 1',
					"This is a piece of scrap material"))

			end

			@items << item

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

			door = @mgr.create_basic_entity

			render_comp = Render.new('door1', @atlas.find_region('door1'))
			w = render_comp.width * C::WTB
			h = render_comp.height * C::WTB

			@mgr.add_component(door, render_comp)
			@mgr.add_component(door, Position.new(x + w/2, y + h/2))
			@mgr.add_component(door, Size.new(w, h))
			@mgr.add_component(door, Rotation.new(rot))
			@mgr.add_component(door, Collision.new)
			@mgr.add_component(door, Type.new('door1'))
			@mgr.add_component(door, Door.new)

			@doors << door

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

			door = @mgr.create_basic_entity

			render_comp = Render.new('door1', @atlas.find_region('door1'))
			w = render_comp.width * C::WTB
			h = render_comp.height * C::WTB

			@mgr.add_component(door, render_comp)
			@mgr.add_component(door, Position.new(x + h/2, y + w/2))
			@mgr.add_component(door, Size.new(w, h))
			@mgr.add_component(door, Rotation.new(rot))
			@mgr.add_component(door, Collision.new)
			@mgr.add_component(door, Type.new('door1'))
			@mgr.add_component(door, Door.new)

			@doors << door

		end

	end
	

	def get_item(x, y)

		@mgr.render.nearby_entities.each do |entity|

			if @items.include?(entity)

				pos_comp = @mgr.get_component(entity, Position)
				render_comp = @mgr.get_component(entity, Render)
				rot_comp = @mgr.get_component(entity, Rotation)

				# Transform coordinates to axis-aligned frame
				c = Math.cos(-rot_comp.angle * Math::PI/180)
				s = Math.sin(-rot_comp.angle * Math::PI/180)
				rot_x = pos_comp.x + c * (x - pos_comp.x) - s * (y - pos_comp.y)
				rot_y = pos_comp.y + s * (x - pos_comp.x) + c * (y - pos_comp.y)

				left   = pos_comp.x - render_comp.width * C::WTB / 2
				right  = pos_comp.x + render_comp.width * C::WTB / 2
				top    = pos_comp.y - render_comp.height * C::WTB / 2
				bottom = pos_comp.y + render_comp.height * C::WTB / 2

				if left <= rot_x && rot_x <= right && top <= rot_y && rot_y <= bottom
					return entity
				end

			end

		end

		nil

	end


	def remove_item(item)

		pos_comp = @mgr.get_component(item, Position)
		render_comp = @mgr.get_component(item, Render)

		@mgr.remove_component(item, pos_comp)
		@mgr.remove_component(item, render_comp)

		@items.delete(item)
		@mgr.inventory.update_slots = true

	end


	def get_door(x, y)

		@mgr.render.nearby_entities.each do |entity|

			if @doors.include?(entity)

				pos_comp = @mgr.get_component(entity, Position)
				render_comp = @mgr.get_component(entity, Render)
				size_comp = @mgr.get_component(entity, Size)
				rot_comp = @mgr.get_component(entity, Rotation)

				# Transform coordinates to axis-aligned frame
				c = Math.cos(-rot_comp.angle * Math::PI/180)
				s = Math.sin(-rot_comp.angle * Math::PI/180)
				rot_x = pos_comp.x + c * (x - pos_comp.x) - s * (y - pos_comp.y)
				rot_y = pos_comp.y + s * (x - pos_comp.x) + c * (y - pos_comp.y)

				left   = pos_comp.x - size_comp.width / 2
				right  = pos_comp.x + size_comp.width / 2
				top    = pos_comp.y - size_comp.height / 2
				bottom = pos_comp.y + size_comp.height / 2

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
				
				pos_comp = @mgr.get_component(entity, Position)
				dist_sqr = (pos_comp.x - x)**2 + (pos_comp.y - y)**2

				if dist_sqr < 2.6
					return entity
				end

			end

		end

		nil

	end


	def change_door(door, open)

		pos_comp = @mgr.get_component(door, Position)
		rot_comp = @mgr.get_component(door, Rotation)
		render_comp = @mgr.get_component(door, Render)
		size_comp = @mgr.get_component(door, Size)
		col_comp = @mgr.get_component(door, Collision)

		if open

			render_comp = @mgr.get_component(door, Render)
			@mgr.remove_component(door, render_comp)
			@mgr.physics.remove_body(col_comp.body)

		else

			type = @mgr.get_component(door, Type).type

			body = @mgr.physics.create_body(
				pos_comp.x, pos_comp.y, 
				size_comp.width, size_comp.height, 
				false, rot_comp.angle)

			@mgr.add_component(
				door, 
				Render.new(type, @atlas.find_region(type)))
		
		end

	end


	def get_near_item(x, y)

		@mgr.render.nearby_entities.each do |entity|

			if @items.include?(entity)
				
				pos_comp = @mgr.get_component(entity, Position)
				dist_sqr = (pos_comp.x - x)**2 + (pos_comp.y - y)**2

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


	def update(delta, batch)

		@start_x = [@focus.x - 13, 0].max.to_i
		@start_y = [@focus.y - 10, 0].max.to_i
		@end_x   = [@focus.x + 13, C::MAP_WIDTH-1].min.to_i
		@end_y   = [@focus.y + 10, C::MAP_HEIGHT-1].min.to_i

		@cam.position.set(@focus.x * C::BTW, @focus.y * C::BTW, 0)
		@cam.update

		batch.projection_matrix = @cam::combined

		batch.begin

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

		batch.end

	end


	def dispose


	end

end