class MapSystem < System

	attr_accessor :width, :height
	attr_accessor :cam, :bodies, :items, :focus, :atlas
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
		@rooms, @items, @bodies = [], [], []
		@num_of_rooms, @num_of_items = 80, 600

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

	end


	def generate_rooms
		
		room_x, room_y = 0, 0
		@master = Room.new(10, 10, C::MAP_WIDTH - 10, C::MAP_HEIGHT - 10)

		for i in 0...@num_of_rooms
		  room_x = Random.rand(@master.x1...@master.x2)
		  room_y = Random.rand(@master.y1...@master.y2)
		  @rooms << Room.new(room_x, room_y, 1, 1)
		end

		for i in 0...@iterations
			@rooms.each do |room|
				expand(room)
			end
		end

		@rooms.each do |room|

			if room.width > 3 && room.height > 3
				
				for rx in room.x1...room.x2
					for ry in room.y1...room.y2

						if rx == room.x1 || rx == room.x2-1

							@solid[rx][ry] = true
							@sight[rx][ry] = false
							@rot[rx][ry]   = 0.0
							@tiles[rx][ry] = @atlas.find_region('wall1')

						elsif ry == room.y1 || ry == room.y2-1

							@solid[rx][ry] = true
							@sight[rx][ry] = false
							@rot[rx][ry]   = 0.0
							@tiles[rx][ry] = @atlas.find_region('wall1')

						else

							@solid[rx][ry] = false
							@sight[rx][ry] = true
							@rot[rx][ry]   = 0.0
							@tiles[rx][ry] = @atlas.find_region('floor2')

						end

					end
				end

				if room.x2 - room.x1 > 3

					dx = Random.rand(room.x1 + 1...room.x2 - 2)

					if Random.rand(2) == 0
						dy = room.y1
					else
						dy = room.y2 - 1
					end

					@solid[dx][dy] = false
					@sight[dx][dy] = true
					@rot[dx][dy]   = 0.0
					@tiles[dx][dy] = @atlas.find_region('floor2')

					@solid[dx+1][dy] = false
					@sight[dx+1][dy] = true
					@rot[dx+1][dy]   = 0.0
					@tiles[dx+1][dy] = @atlas.find_region('floor2')

				end

				if room.y2 - room.y1 > 3

					dy = Random.rand(room.y1 + 1...room.y2 - 2)

					if Random.rand(2) == 0
						dx = room.x1
					else
						dx = room.x2 - 1
					end

					@solid[dx][dy] = false
					@sight[dx][dy] = true
					@rot[dx][dy]   = 0.0
					@tiles[dx][dy] = @atlas.find_region('floor2')

					@solid[dx][dy+1] = false
					@sight[dx][dy+1] = true
					@rot[dx][dy+1]   = 0.0
					@tiles[dx][dy+1] = @atlas.find_region('floor2')

				end

			end

		end

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


	def intersects(room1, room2)
		!(room1.x2 < room2.x1 || room2.x2 < room1.x1 || room1.y2 < room2.y1 || room2.y2 < room1.y1)
	end


	def generate_items

		item_x, item_y = 0, 0

		for i in 0...@num_of_items

			loop do
				item_x = Random.rand(10.0...@width-10)
				item_y = Random.rand(10.0...@height-10)
				
				break if !@solid[item_x.to_i][item_y.to_i]
			end

			item = @mgr.create_basic_entity

			@mgr.add_component(item, Position.new(item_x, item_y))
			@mgr.add_component(item, Rotation.new(Random.rand(360)))
			@mgr.add_component(item, Item.new)

			check = Random.rand
			if check < 0.33

				@mgr.add_component(item, Type.new('canteen1'))
				@mgr.add_component(item, Render.new('canteen1'))
				@mgr.add_component(item, Info.new(
					'Canteen 1',
					"This is a drinking canteen."))
				
			elsif check < 0.66

				@mgr.add_component(item, Type.new('rations1'))
				@mgr.add_component(item, Render.new('rations1'))
				@mgr.add_component(item, Info.new(
					'Rations 1',
					"This is rations container."))

			elsif check < 0.88

				@mgr.add_component(item, Type.new('overgrowth1'))
				@mgr.add_component(item, Render.new('overgrowth1'))
				@mgr.add_component(item, Info.new(
					'Overgrowth 1',
					"The root of some overgrowth."))

				6.times do

					sub_item = @mgr.create_basic_entity

					xx = Random.rand(item_x - 1.2..item_x + 1.2)
					yy = Random.rand(item_y - 1.2..item_y + 1.2)

					@mgr.add_component(sub_item, Position.new(xx, yy))
					@mgr.add_component(sub_item, Rotation.new(Random.rand(360)))
					@mgr.add_component(sub_item, Item.new)

					@mgr.add_component(sub_item, Type.new('ruffage1'))
					@mgr.add_component(sub_item, Render.new('ruffage1'))
					@mgr.add_component(sub_item, Info.new(
						'Ruffage 1',
						"Stray vines and roots."))

					@items << sub_item

				end

			else

				@mgr.add_component(item, Type.new('scrap1'))
				@mgr.add_component(item, Render.new('scrap1'))
				@mgr.add_component(item, Info.new(
					'Scrap 1',
					"This is a piece of scrap material."))

			end

			@items << item

		end

	end


	def remove_item(item)

		pos_comp = @mgr.get_component(item, Position)
		render_comp = @mgr.get_component(item, Render)

		@mgr.remove_component(item, pos_comp)
		@mgr.remove_component(item, render_comp)

		@items.delete(item)
		@mgr.inventory.update = true

	end


	def get_item(x, y)

		entities = @mgr.get_all_entities_with(Item)
		entities.each do |entity|

			if @items.include?(entity)

				pos_comp = @mgr.get_component(entity, Position)
				render_comp = @mgr.get_component(entity, Render)
				rot_comp = @mgr.get_component(entity, Rotation)

				c = Math.cos(-rot_comp.angle * Math::PI/180)
				s = Math.sin(-rot_comp.angle * Math::PI/180)

				# Transform coordinates to axis-aligned frame
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


	def get_nearest_item(x, y)

		dist = 1.6
		item_choice = nil

		entities = @mgr.get_all_entities_with(Item)
		entities.each do |entity|

			if @items.include?(entity)
				
				pos_comp = @mgr.get_component(entity, Position)
				tmp_dist = (pos_comp.x - x)**2 + (pos_comp.y - y)**2

				if tmp_dist < dist
					dist = tmp_dist
					item_choice = entity
				end

			end

		end

		item_choice

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

end