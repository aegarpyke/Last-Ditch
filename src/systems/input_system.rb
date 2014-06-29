class InputSystem < System

	attr_accessor :user_adapter

	def initialize(mgr)

		@mgr = mgr
		@ctrl = false
		@shift = false
		@user_adapter = UserAdapter.new(self)

	end


	def touch_down(screen_x, screen_y, pointer, button)

		@mgr.ui.inv_active and @mgr.ui.inv_no_exit = true
		@mgr.ui.base_active and @mgr.ui.base_no_exit = true

		entities = @mgr.entities_with(UserInput)
		entities.each do |entity|

			case button

				when 0

					if !@shift

						if @mgr.ui.main_active

						else
							pickup_item(entity)
						end

					else

						if @mgr.ui.main_active

						else

							pickup_item_at(entity, screen_x, screen_y) or
							use_door_at(entity, screen_x, screen_y)
							
						end

					end

				when 1

					if !@shift

						if @mgr.ui.main_active
							drop_item(entity)
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

				when Keys::E

					if !@shift

						if @mgr.ui.main_active

						else
							use_door(entity)
						end

					else

						
					end

				when Keys::C

					if !@shift

					else

					end

				when Keys::TAB
					
					if !@ctrl

						@mgr.ui.main_update = true

						vel = @mgr.comp(entity, Velocity)
						vel.spd = 0
						vel.ang_spd = 0
						
						@mgr.paused         = !@mgr.paused
						@mgr.ui.main_active = !@mgr.ui.main_active
						@mgr.time.active    = !@mgr.time.active

					else

						@mgr.ui.base_update = true
						@mgr.ui.base_active = !@mgr.ui.base_active
							
					end

				when Keys::W, Keys::UP

					if !@shift

						if @mgr.ui.main_active

							@mgr.ui.actions_update = true
							@mgr.ui.actions_active = !@mgr.ui.actions_active

						else

							vel = @mgr.comp(entity, Velocity)
							vel.spd = C::PLAYER_SPD

						end

					end

				when Keys::S, Keys::DOWN

					if !@shift
						
						if @mgr.ui.main_active

							@mgr.ui.inv_update = true
							@mgr.ui.inv_active = !@mgr.ui.inv_active

						else

							vel = @mgr.comp(entity, Velocity)
							vel.spd = -C::PLAYER_SPD * 0.5

						end

					end

				when Keys::A, Keys::LEFT

					if !@shift

						if @mgr.ui.main_active

							@mgr.ui.equip_update = true
							@mgr.ui.equip_active = !@mgr.ui.equip_active

						else

							vel = @mgr.comp(entity, Velocity)
							vel.ang_spd = C::PLAYER_ROT_SPD

						end
						
					else

						if @mgr.ui.main_active

						else

							vel = @mgr.comp(entity, Velocity)
							vel.ang_spd = 0.5 * C::PLAYER_ROT_SPD

						end

					end

				when Keys::D, Keys::RIGHT

					if !@shift

						if @mgr.ui.main_active

							@mgr.ui.status_update = true
							@mgr.ui.status_active = !@mgr.ui.status_active

						else

							vel = @mgr.comp(entity, Velocity)
							vel.ang_spd = -C::PLAYER_ROT_SPD
						
						end

					else

						if @mgr.ui.main_active

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

					if @mgr.ui.main_active

					else

						vel = @mgr.comp(entity, Velocity)
						vel.spd = 0

					end

				when Keys::A, Keys::D, Keys::LEFT, Keys::RIGHT

					if @mgr.ui.main_active

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



	def pickup_item(entity)

		pos = @mgr.comp(entity, Position)
		inv = @mgr.comp(entity, Inventory)

		item_id = @mgr.map.get_near_item(pos.x, pos.y) and
		inv.add_item(item_id)													 and

		Proc.new do

			item = @mgr.comp(item_id, Item)
			inv.weight += item.weight 
			@mgr.ui.inv_prev_selection = nil
			@mgr.map.remove_item(item_id)

			return true
		
		end.call

		false

	end


	def pickup_item_at(entity, screen_x, screen_y)

		pos = @mgr.comp(entity, Position)
		inv = @mgr.comp(entity, Inventory)

		x = pos.x + C::WTB * (screen_x - C::WIDTH / 2)
		y = pos.y - C::WTB * (screen_y - C::HEIGHT / 2)

		item_id = @mgr.map.get_item(x, y) and		
		inv.add_item(item_id)             and

		Proc.new do

			item = @mgr.comp(item_id, Item)
			inv.weight += item.weight
			@mgr.ui.inv_prev_selection = nil
			@mgr.map.remove_item(item_id)

			return true

		end.call

		false

	end


	def drop_item(entity)

		pos = @mgr.comp(entity, Position)
		inv = @mgr.comp(entity, Inventory)
		rot = @mgr.comp(entity, Rotation)

		@mgr.ui.inv_selection                                  and
		index = @mgr.ui.inv_slots.index(@mgr.ui.inv_selection) and
		item_id = inv.items[index]														 and

		Proc.new do

			item_type = @mgr.comp(item_id, Type)

			item_pos = Position.new(
				pos.x + rot.x, 
				pos.y + rot.y)

			item_render = Render.new(
				item_type.type,
				@mgr.atlas.find_region(item_type.type))

			item_rot = @mgr.comp(item_id, Rotation)
			item_rot.angle = rot.angle - 90

			@mgr.add_comp(item_id, item_pos)
			@mgr.add_comp(item_id, item_render)

			@mgr.map.items << item_id
			item = @mgr.comp(item_id, Item)
			inv.weight -= item.weight 
			inv.remove_item(item_id)
			@mgr.render.nearby_entities << item_id
			@mgr.ui.set_inv_name("")
			@mgr.ui.set_inv_desc("")
			@mgr.ui.set_inv_qual_cond(-1, -1)
			@mgr.ui.set_inv_value(-1)
			@mgr.ui.set_inv_weight(-1)
			@mgr.inventory.update_slots = true

			return true

		end.call

		false

	end


	def use_door(entity)

		pos = @mgr.comp(entity, Position)
		inv = @mgr.comp(entity, Inventory)

		door_id = @mgr.map.get_near_door(pos.x, pos.y) and
		door    = @mgr.comp(door_id, Door)             and
		!door.locked                                   and

		Proc.new do
		
			door.open = !door.open
			@mgr.map.change_door(door_id, door.open)

			return true

		end.call

		false

	end


	def use_door_at(entity, screen_x, screen_y)

		pos = @mgr.comp(entity, Position)
		inv = @mgr.comp(entity, Inventory)

		x = pos.x + C::WTB * (screen_x - C::WIDTH / 2)
		y = pos.y - C::WTB * (screen_y - C::HEIGHT / 2)

		door_id = @mgr.map.get_door(x, y)  and
		door    = @mgr.comp(door_id, Door) and
		!door.locked                       and

		Proc.new do

			door.open = !door.open
			@mgr.map.change_door(door_id, door.open)

			return true

		end.call

		false

	end


	def dispose

	end

end
