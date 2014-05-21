class Animation < Component

	attr_accessor :anims, :names_and_frames, :cur, :state_time, :key_frame, :scale

	def initialize(names_and_frames)

		super()
		@scale = 1.0
		@state_time = 0.0
		@anims = Hash.new
		@names_and_frames = names_and_frames

	end

	def key_frame
		@cur.get_key_frame(@state_time, true)
	end

	def width
		key_frame.packedWidth
	end

	def height
		key_frame.packedHeight
	end

	def cur=(name)
		@cur = @anims[name]
	end

end