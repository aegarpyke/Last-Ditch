class UserAdapter < InputAdapter

	def initialize(mgr, player)

		super()
		@mgr = mgr
		@shift = false
		@player = player

	end


	def keyDown(keycode)

		case keycode

			when Keys::SHIFT_LEFT, Keys::SHIFT_RIGHT
				@shift = true

			when Keys::ESCAPE
				Gdx.app.exit

			when Keys::TAB
				@mgr.ui.update = true
				@mgr.paused = !@mgr.paused
				@mgr.ui.active = @mgr.paused

			when Keys::F
				if @shift
					puts 'pick specific item with mouse'
				else

					pos_comp = @mgr.get_component(@player, Position)
					inv_comp = @mgr.get_component(@player, Inventory)

					item = @mgr.map.get_nearest_item(pos_comp.x, pos_comp.y)

					@mgr.map.remove_item(item)
					inv_comp.add_item(item) if item

				end

			when Keys::C
				puts 'take cover'
				
					
		end

	end


	def keyUp(keycode)

		case keycode

			when Keys::SHIFT_LEFT, Keys::SHIFT_RIGHT
				@shift = false

		end

	end

end