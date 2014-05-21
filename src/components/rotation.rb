class Rotation < Component

	attr_accessor :angle, :x, :y

	def initialize(angle)

		super()
		@angle = angle
		@x = Math.cos(angle * Math::PI / 180.0)
		@y = Math.sin(angle * Math::PI / 180.0)

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
		@x = Math.cos(@angle * Math::PI / 180.0)
		@y = Math.sin(@angle * Math::PI / 180.0)
	
	end

end