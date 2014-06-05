class UserAdapter < InputAdapter

	def initialize(input_system)

		super()
		@input_system = input_system
		
	end


	def touchDown(screenX, screenY, pointer, button)

		@input_system.touch_down(screenX, screenY, pointer, button)

	end


	def keyDown(keycode)

		@input_system.key_down(keycode)

	end


	def keyUp(keycode)

		@input_system.key_up(keycode)

	end

end