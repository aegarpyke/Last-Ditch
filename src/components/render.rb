class Render < Component

	attr_accessor :region, :region_name, :width, :height, :scale

	def initialize(region_name, region=nil)

		@scale = 1.0
		@region = region
		@region_name = region_name

	end

	def width
		@region.region_width
	end

	def height
		@region.region_height
	end

end