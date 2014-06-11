class Rotation < Component

	attr_accessor :angle, :p_angle, :x, :y

	def initialize(angle)

		super()
		@angle = @p_angle = angle
		@x = Math.cos(angle * Math::PI / 180)
		@y = Math.sin(angle * Math::PI / 180)

	end


	def angle=(angle)

		@angle = angle
		@x = Math.cos(angle * Math::PI / 180)
		@y = Math.sin(angle * Math::PI / 180)

	end


	def x=(x)
		
		@x = x
		@angle = Math.atan(@y / x)
	
	end


	def y=(y)

		@y = y		
		@angle = Math.atan(y / @x)

	end


	def rotate(amount)

		@angle += amount
		@x = Math.cos(@angle * Math::PI / 180)
		@y = Math.sin(@angle * Math::PI / 180)
	
	end

end