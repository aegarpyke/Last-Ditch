class InputSystem < System

	attr_accessor :user_adapter

	def initialize(mgr, player)

		@mgr = mgr
		@player = player
		@user_adapter = UserAdapter.new(mgr, player)

	end


	def tick(delta)

		unless @mgr.paused
			
			vel_comp = @mgr.get_component(@player, Velocity)
			rot_comp = @mgr.get_component(@player, Rotation)
			input_comp = @mgr.get_component(@player, UserInput)

			if Gdx.input.is_key_pressed(Keys::W) && input_comp.responsive_keys.include?(Keys::W)

				vel_comp.spd = delta * C::PLAYER_SPD

			elsif Gdx.input.is_key_pressed(Keys::S) && input_comp.responsive_keys.include?(Keys::S)

				vel_comp.spd = -delta * C::PLAYER_SPD * 0.6

			else

				vel_comp.spd = 0.0

			end

			if Gdx.input.is_key_pressed(Keys::A) && input_comp.responsive_keys.include?(Keys::A)

				rot_comp.rotate(delta * C::PLAYER_ROT_SPD)

			elsif Gdx.input.is_key_pressed(Keys::D) && input_comp.responsive_keys.include?(Keys::D)

				rot_comp.rotate(-delta * C::PLAYER_ROT_SPD)

			end

		end

	end


	def dispose

	end

end
