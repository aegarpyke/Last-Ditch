class UserAdapter < InputAdapter

	def initialize(mgr, player)

		super()
		@mgr = mgr
		@ctrl = false
		@shift = false
		@player = player

	end


	def touchDown(screenX, screenY, pointer, button)

		case button

			when 0
				
				if @shift

					pos_comp = @mgr.get_component(@player, Position)

					puts @mgr.map.get_item(
						screenX * C::WTB + pos_comp.x - Gdx.graphics.width/2 * C::WTB, 
						screenY * C::WTB + pos_comp.y - Gdx.graphics.height/2 * C::WTB)					

				else
				
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


	def keyDown(keycode)

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
					@mgr.ui.main_update = true
					@mgr.ui.main_active = @mgr.paused
					
				end

				return true

			when Keys::F

				if @shift
					puts 'pick specific item with mouse'
				else

					pos_comp = @mgr.get_component(@player, Position)
					inv_comp = @mgr.get_component(@player, Inventory)

					item = @mgr.map.get_nearest_item(pos_comp.x, pos_comp.y)

					if item && inv_comp.add_item(item)
						@mgr.map.remove_item(item)
					end

				end

				return true

			when Keys::C
				puts 'take cover'
				return true
					
		end

	end


	def keyUp(keycode)

		case keycode

			when Keys::CONTROL_LEFT, Keys::CONTROL_RIGHT

				@ctrl = false
				return true

			when Keys::SHIFT_LEFT, Keys::SHIFT_RIGHT

				@shift = false
				return true

		end

	end

end