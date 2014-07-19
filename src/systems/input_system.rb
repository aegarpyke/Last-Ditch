class InputSystem < System

	attr_accessor :user_adapter

	def initialize(mgr)

		@mgr = mgr
		@ctrl = false
		@shift = false
		@user_adapter = UserAdapter.new(self)

	end


	def touch_down(screen_x, screen_y, pointer, button)

		entities = @mgr.entities_with(UserInput)
		entities.each do |entity|

			case button

				when 0

					if !@shift
						
						if @mgr.skill_test.testing
							@mgr.skill_test.score
						else
							@mgr.inventory.pickup_item(entity)
						end

					else
						
						if @mgr.ui.active
							
						else
						
							@mgr.inventory.pickup_item_at(entity, screen_x, screen_y) or
							@mgr.map.use_door_at(entity, screen_x, screen_y)

						end

					end

				when 1

					if !@shift

						if @mgr.ui.base.active

							@mgr.ui.base.no_exit = true

						end

						if @mgr.ui.active

							@mgr.ui.inv.no_exit = true
							@mgr.map.drop_item(entity)
						
						end

					else

					end

			end

		end

		true

	end


	def key_down(keycode)

		entities = @mgr.entities_with(UserInput)
		entities.each do |entity|

			case keycode

				when Keys::TAB
					
					if !@ctrl

						vel = @mgr.comp(entity, Velocity)
						vel.spd = 0
						vel.ang_spd = 0

						@mgr.paused = !@mgr.paused
						@mgr.actions.cur_station = nil
						
						if @mgr.ui.active
							@mgr.skill_test.deactivate
							@mgr.ui.deactivate
						else
							@mgr.ui.activate
						end

					else

						@mgr.ui.base.toggle_active
							
					end

				when Keys::E

					if !@shift

						if @mgr.ui.active

							@mgr.ui.deactivate

						else

							@mgr.map.use_door(entity)    or
							@mgr.map.use_station(entity)

						end

					else
						
					end

				when Keys::C

					if !@shift

					else

					end

				when Keys::W, Keys::UP

					if !@shift

						if @mgr.ui.active

							@mgr.ui.actions.toggle_active

						else

							vel = @mgr.comp(entity, Velocity)
							vel.spd = C::PLAYER_SPD

						end

					end

				when Keys::S, Keys::DOWN

					if !@shift
						
						if @mgr.ui.active

							@mgr.ui.inv.toggle_active

						else

							vel = @mgr.comp(entity, Velocity)
							vel.spd = -C::PLAYER_SPD * 0.5

						end

					end

				when Keys::A, Keys::LEFT

					if !@shift

						if @mgr.ui.active

							@mgr.ui.equip.toggle_active

						else

							vel = @mgr.comp(entity, Velocity)
							vel.ang_spd = C::PLAYER_ROT_SPD

						end
						
					else

						if @mgr.ui.active



						else

							vel = @mgr.comp(entity, Velocity)
							vel.ang_spd = 0.5 * C::PLAYER_ROT_SPD

						end

					end

				when Keys::D, Keys::RIGHT

					if !@shift

						if @mgr.ui.active

							@mgr.ui.status.toggle_active

						else

							vel = @mgr.comp(entity, Velocity)
							vel.ang_spd = -C::PLAYER_ROT_SPD
						
						end

					else

						if @mgr.ui.active

						else

							vel = @mgr.comp(entity, Velocity)
							vel.ang_spd = -0.5 * C::PLAYER_ROT_SPD

						end

					end

				when Keys::CONTROL_LEFT, Keys::CONTROL_RIGHT

					@ctrl = true

				when Keys::SHIFT_LEFT, Keys::SHIFT_RIGHT
					
					@shift = true

				when Keys::ESCAPE
					
					Gdx.app.exit
						
			end

		end

		true

	end


	def key_up(keycode)

		entities = @mgr.entities_with(UserInput)
		entities.each do |entity|

			case keycode

				when Keys::W, Keys::S, Keys::UP, Keys::DOWN

					if @mgr.ui.active

					else

						vel = @mgr.comp(entity, Velocity)
						vel.spd = 0

					end

				when Keys::A, Keys::D, Keys::LEFT, Keys::RIGHT

					if @mgr.ui.active

					else

						vel = @mgr.comp(entity, Velocity)
						vel.ang_spd = 0

					end

				when Keys::CONTROL_LEFT, Keys::CONTROL_RIGHT
					
					@ctrl = false
				
				when Keys::SHIFT_LEFT, Keys::SHIFT_RIGHT
					
					@shift = false

			end

		end

		true

	end


	def dispose

	end

end
