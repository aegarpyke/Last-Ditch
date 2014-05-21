class Map

	attr_accessor :width, :height
	attr_accessor :cam, :bodies, :items, :focus, :atlas
	attr_accessor :tiles, :solid, :sight, :rot

	def initialize(mgr, width, height)

		@mgr = mgr
		@atlas = mgr.atlas

		@tiles = Array.new(width) {|i| Array.new(height) {|i| @mgr.atlas.find_region('floor1')}}
		@solid = Array.new(width) {|i| Array.new(height) {|i| false }}
		@sight = Array.new(width) {|i| Array.new(height) {|i| true }}
		@rot   = Array.new(width) {|i| Array.new(height) {|i| 0.0}}

		@items, @bodies = [], []		
		@width, @height = width, height

		@cam = OrthographicCamera.new
		@cam.set_to_ortho(false, C::WIDTH, C::HEIGHT)

		for x in 0...@width
			for y in 0...@height

				if x == 0 || y == 0 || x == @width-1 || y == @height-1

					@tiles[x][y] = @atlas.find_region('empty')
					@solid[x][y] = true
					@sight[x][y] = true

				end

			end

		end

		@chunks = []

		@chunks << Chunk.new(self, 8, 8, 40, 40)
		# @chunks << Chunk.new(self, 8, 60, 40, 40)
		# @chunks << Chunk.new(self, 60, 8, 40, 40)
		# @chunks << Chunk.new(self, 60, 60, 40, 40)

		generate_items

	end


	def generate_items

		rx, ry = 0, 0
		num_of_items = 1000

		for i in 0...num_of_items

			loop do
				rx = Random.rand(10.0...@width-10)
				ry = Random.rand(10.0...@height-10)
				
				break if !@solid[rx.to_i][ry.to_i]
			end

			item = @mgr.create_basic_entity
			@mgr.add_component(item, Position.new(rx, ry))
			@mgr.add_component(item, Rotation.new(Random.rand(360)))
			@mgr.add_component(item, Item.new)

			check = Random.rand
			if check < 0.33
				@mgr.add_component(item, Render.new('canteen1'))
			elsif check < 0.66
				@mgr.add_component(item, Render.new('rations1'))
			else
				@mgr.add_component(item, Render.new('scrap1'))
			end

		end

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

		batch.set_projection_matrix(@cam::combined)

		for x in @start_x..@end_x
			for y in @start_y..@end_y

				batch.draw(
					@tiles[x][y],
					x * C::BTW, y * C::BTW,
					C::BTW/2, C::BTW/2, 
					C::BTW, C::BTW,
					1.0, 1.0,
					@rot[x][y])

			end
		end

	end

end