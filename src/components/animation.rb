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

		if key_frame.respond_to?('packedWidth')
			return key_frame.packedWidth
		else
			return key_frame.regionWidth
		end

	end

	def height
		
		if key_frame.respond_to?('packedHeight')
			return key_frame.packedHeight
		else
			return key_frame.regionHeight
		end

	end

	def cur=(name)
		@cur = @anims[name]
	end

end