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

		true

	end


	def key_down(keycode)

		case keycode

			when Keys::CONTROL_LEFT, Keys::CONTROL_RIGHT

				@ctrl = true

			when Keys::SHIFT_LEFT, Keys::SHIFT_RIGHT
				
				@shift = true

			when Keys::ESCAPE
				
				Gdx.app.exit

			when Keys::TAB
				
				if @ctrl

					@mgr.ui.base_update = true
					@mgr.ui.base_active = !@mgr.ui.base_active

				else

					vel_comp = @mgr.get_component(@player, Velocity)
					vel_comp.spd = 0
					vel_comp.ang_spd = 0

					@mgr.paused = !@mgr.paused
					@mgr.time.active = !@mgr.time.active
					@mgr.ui.main_update = true
					@mgr.ui.main_active = @mgr.paused
					
				end

			when Keys::W, Keys::UP

				if @mgr.ui.main_active

					@mgr.ui.actions_update = true
					@mgr.ui.actions_active = !@mgr.ui.actions_active

				else

					vel_comp = @mgr.get_component(@player, Velocity)
					vel_comp.spd = C::PLAYER_SPD

				end

			when Keys::S, Keys::DOWN
				
				if @mgr.ui.main_active

					@mgr.ui.inv_update = true
					@mgr.ui.inv_active = !@mgr.ui.inv_active

				else

					vel_comp = @mgr.get_component(@player, Velocity)
					vel_comp.spd = -C::PLAYER_SPD * 0.5

				end

			when Keys::A, Keys::LEFT

				if @mgr.ui.main_active

					@mgr.ui.equip_update = true
					@mgr.ui.equip_active = !@mgr.ui.equip_active

				else

					vel_comp = @mgr.get_component(@player, Velocity)
					vel_comp.ang_spd = C::PLAYER_ROT_SPD

				end

			when Keys::D, Keys::RIGHT

				if @mgr.ui.main_active

					@mgr.ui.status_update = true
					@mgr.ui.status_active = !@mgr.ui.status_active

				else

					vel_comp = @mgr.get_component(@player, Velocity)
					vel_comp.ang_spd = -C::PLAYER_ROT_SPD

				end

			
			when Keys::F

				if @shift

				else

				end

			when Keys::C
				puts 'take cover'
					
		end

		true

	end


	def key_up(keycode)

		case keycode

			when Keys::CONTROL_LEFT, Keys::CONTROL_RIGHT
				
				@ctrl = false
			
			when Keys::SHIFT_LEFT, Keys::SHIFT_RIGHT
				
				@shift = false

			when Keys::W, Keys::S, Keys::UP, Keys::DOWN

				unless @mgr.ui.main_active

					vel_comp = @mgr.get_component(@player, Velocity)
					vel_comp.spd = 0

				end

			when Keys::A, Keys::D, Keys::LEFT, Keys::RIGHT

				unless @mgr.ui.main_active

					vel_comp = @mgr.get_component(@player, Velocity)
					vel_comp.ang_spd = 0

				end

		end

		true

	end


	def dispose

	end

end
