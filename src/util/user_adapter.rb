class UserAdapter < InputAdapter

	def initialize(input_system)
		super()
		@input_system = input_system
	end

	def touchDown(screen_x, screen_y, pointer, button)
		@input_system.touch_down(screen_x, screen_y, pointer, button)
	end

	def keyDown(keycode)
		@input_system.key_down(keycode)
	end

	def keyUp(keycode)
		@input_system.key_up(keycode)
	end

end
