class InputSystem < System

	attr_accessor :user_adapter

	def initialize(mgr, player)

		@mgr = mgr
		@ctrl = false
		@shift = false
		@player = player
		@user_adapter = UserAdapter.new(self)

	end


	def update(delta)

		unless @mgr.paused
			
			vel_comp = @mgr.get_component(@player, Velocity)
			rot_comp = @mgr.get_component(@player, Rotation)
			input_comp = @mgr.get_component(@player, UserInput)

			if Gdx.input.is_key_pressed(Keys::W)
				vel_comp.spd = delta * C::PLAYER_SPD
			elsif Gdx.input.is_key_pressed(Keys::S)
				vel_comp.spd = -delta * C::PLAYER_SPD * 0.5
			else
				vel_comp.spd = 0.0
			end

			if Gdx.input.is_key_pressed(Keys::A)
				rot_comp.rotate(delta * C::PLAYER_ROT_SPD)
			elsif Gdx.input.is_key_pressed(Keys::D)
				rot_comp.rotate(-delta * C::PLAYER_ROT_SPD)
			end

		end

	end


	def touch_down(screenX, screenY, pointer, button)

		case button

			when 0
				
				if @shift
					# Pickup specific item with shift-left click
					pos_comp = @mgr.get_component(@player, Position)
					inv_comp = @mgr.get_component(@player, Inventory)

					world_x = pos_comp.x + C::WTB * (screenX - Gdx.graphics.width/2)
					world_y = pos_comp.y - C::WTB * (screenY - Gdx.graphics.height/2)

					item = @mgr.map.get_item(world_x, world_y)					
					dist = (world_x - pos_comp.x)**2 + (world_y - pos_comp.y)**2

					if item && dist < 1.4 && inv_comp.add_item(item)
						@mgr.map.remove_item(item)
					end

				else
					# Pickup nearest item with left click
					pos_comp = @mgr.get_component(@player, Position)
					inv_comp = @mgr.get_component(@player, Inventory)

					item = @mgr.map.get_nearest_item(pos_comp.x, pos_comp.y)

					if item && inv_comp.add_item(item)
						@mgr.map.remove_item(item)
					end
				
				end

			when 1
				puts "right?"

		end

		return true

	end


	def key_down(keycode)

		case keycode

			when Keys::CONTROL_LEFT, Keys::CONTROL_RIGHT

				@ctrl = true
				return true

			when Keys::SHIFT_LEFT, Keys::SHIFT_RIGHT
				
				@shift = true
				return true

			when Keys::ESCAPE
				
				Gdx.app.exit
				return true

			when Keys::TAB
				
				if @ctrl

					@mgr.ui.base_update = true
					@mgr.ui.base_active = !@mgr.ui.base_active

				else

					@mgr.paused = !@mgr.paused
					@mgr.time.active = !@mgr.time.active
					@mgr.ui.main_update = true
					@mgr.ui.main_active = @mgr.paused
					
				end

				return true

			when Keys::W

				if @mgr.ui.main_active

					@mgr.ui.actions_update = true
					@mgr.ui.actions_active = !@mgr.ui.actions_active
					return true

				end

			when Keys::A

				if @mgr.ui.main_active

					@mgr.ui.equip_update = true
					@mgr.ui.equip_active = !@mgr.ui.equip_active
					return true

				end

			when Keys::D

				if @mgr.ui.main_active

					@mgr.ui.status_update = true
					@mgr.ui.status_active = !@mgr.ui.status_active
					return true

				end

			when Keys::S
				
				if @mgr.ui.main_active

					@mgr.ui.inv_update = true
					@mgr.ui.inv_active = !@mgr.ui.inv_active
					return true

				end

			when Keys::F

				if @shift

				else

				end

				return true

			when Keys::C
				puts 'take cover'
				return true
					
		end

	end


	def key_up(keycode)

		case keycode

			when Keys::CONTROL_LEFT, Keys::CONTROL_RIGHT

				@ctrl = false
				return true

			when Keys::SHIFT_LEFT, Keys::SHIFT_RIGHT

				@shift = false
				return true

		end

	end


	def dispose

	end

end
