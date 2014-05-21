class Chunk

	# Should probably be a method in map

	attr_accessor :x, :y, :width, :height

	def initialize(map, x, y, width, height)

		@map = map
		@x, @y = x, y
		@iterations = 1000
		@num_rooms = 40
		@width, @height = width, height

		@rooms = []
		@master = Room.new(@x, @y, @x + @width, @y + @height)

		for i in 0...@num_rooms
		  rx = Random.rand(@master.x1...@master.x2)
		  ry = Random.rand(@master.y1...@master.y2)
		  @rooms << Room.new(rx, ry, 1, 1)
		end

		for i in 0...@iterations

			@rooms.each do |room|
				room.expand(@rooms, @master)
			end

		end

		for mx in @master.x1..@master.x2+1
			for my in @master.y1..@master.y2+1

				if mx == @master.x1 || my == @master.y1 || mx == @master.x2+1 || my == @master.y2+1

					map.tiles[mx][my] = @map.atlas.find_region('wall1')
					map.solid[mx][my] = true
					map.sight[mx][my] = false
					map.rot[mx][my] = 0.0							

				else

					map.tiles[mx][my] = @map.atlas.find_region('floor2')
					map.solid[mx][my] = false
					map.sight[mx][my] = true
					map.rot[mx][my] = 0.0				

				end

			end

		end

		@rooms.each do |room|

			for rx in room.x1..room.x2+1
				for ry in room.y1..room.y2+1

					if rx == room.x1 || rx == room.x2+1

						if Random.rand(1.0) < 0.2
							
							map.tiles[rx][ry] = @map.atlas.find_region('floor2')
							map.solid[rx][ry] = false
							map.sight[rx][ry] = true
							map.rot[rx][ry] = 0.0

							map.tiles[rx][ry+1] = @map.atlas.find_region('floor2')
							map.solid[rx][ry+1] = false
							map.sight[rx][ry+1] = true
							map.rot[rx][ry+1] = 0.0							

						else

							map.tiles[rx][ry] = @map.atlas.find_region('wall1')
							map.solid[rx][ry] = true
							map.sight[rx][ry] = false
							map.rot[rx][ry] = 0.0

						end

					elsif ry == room.y1 || ry == room.y2+1

						if Random.rand(1.0) < 0.2
							
							map.tiles[rx][ry] = @map.atlas.find_region('floor2')
							map.solid[rx][ry] = false
							map.sight[rx][ry] = true
							map.rot[rx][ry] = 0.0

							map.tiles[rx-1][ry] = @map.atlas.find_region('floor2')
							map.solid[rx-1][ry] = false
							map.sight[rx-1][ry] = true
							map.rot[rx-1][ry] = 0.0								

						else

							map.tiles[rx][ry] = @map.atlas.find_region('wall1')
							map.solid[rx][ry] = true
							map.sight[rx][ry] = false
							map.rot[rx][ry] = 0.0

						end

					end

				end

			end

		end

	end

end