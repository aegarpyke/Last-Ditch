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

						if @mgr.ui.active

						else
							pickup_item(entity)
						end

					else

						if @mgr.ui.active

						else

							pickup_item_at(entity, screen_x, screen_y) or
							use_door_at(entity, screen_x, screen_y)
							
						end

					end

				when 1

					if !@shift

						if @mgr.ui.base.active

							@mgr.ui.base.no_exit = true

						end

						if @mgr.ui.active

							@mgr.ui.inv.no_exit = true

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

						if @mgr.ui.active

						else
							use_door(entity)				or
							use_station(entity)
						end

					else

						
					end

				when Keys::C

					if !@shift

					else

					end

				when Keys::TAB
					
					if !@ctrl

						vel = @mgr.comp(entity, Velocity)
						vel.spd = 0
						vel.ang_spd = 0

						@mgr.ui.toggle = true
						@mgr.paused = !@mgr.paused
						@mgr.actions.cur_station = nil
						@mgr.ui.actions.set_station_highlight(false)
						@mgr.ui.actions.update_action_info

					else

						@mgr.ui.base.toggle = true
							
					end

				when Keys::W, Keys::UP

					if !@shift

						if @mgr.ui.active

							@mgr.ui.actions.toggle = true

						else

							vel = @mgr.comp(entity, Velocity)
							vel.spd = C::PLAYER_SPD

						end

					end

				when Keys::S, Keys::DOWN

					if !@shift
						
						if @mgr.ui.active

							@mgr.ui.inv.toggle = true

						else

							vel = @mgr.comp(entity, Velocity)
							vel.spd = -C::PLAYER_SPD * 0.5

						end

					end

				when Keys::A, Keys::LEFT

					if !@shift

						if @mgr.ui.active

							@mgr.ui.equip.toggle = true

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

							@mgr.ui.status.toggle = true

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



	def pickup_item(entity)

		pos = @mgr.comp(entity, Position)
		inv = @mgr.comp(entity, Inventory)

		item_id = @mgr.map.get_near_item(pos.x, pos.y) and
		inv.add_item(item_id)													 and

		Proc.new do

			item = @mgr.comp(item_id, Item)
			inv.weight += item.weight 
			
			@mgr.map.remove_item(item_id)
			@mgr.ui.inv.prev_selection = nil

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
			@mgr.ui.inv.prev_selection = nil
			@mgr.map.remove_item(item_id)

			return true

		end.call

		false

	end


	def drop_item(entity)

		pos = @mgr.comp(entity, Position)
		inv = @mgr.comp(entity, Inventory)
		rot = @mgr.comp(entity, Rotation)

		@mgr.ui.inv.selection                                  and
		index = @mgr.ui.inv.slots.index(@mgr.ui.inv.selection) and
		item_id = inv.items[index]														 and

		Proc.new do

			item_type = @mgr.comp(item_id, Type)

			item_pos = Position.new(
				pos.x + rot.x, 
				pos.y + rot.y)

			item_render = Render.new(
				"items/#{item_type.type}",
				@mgr.atlas.find_region("items/#{item_type.type}"))

			item_rot = @mgr.comp(item_id, Rotation)
			item_rot.angle = rot.angle - 90

			@mgr.add_comp(item_id, item_pos)
			@mgr.add_comp(item_id, item_render)

			@mgr.map.items << item_id
			@mgr.inventory.update_slots = true

			item = @mgr.comp(item_id, Item)
			
			inv.weight -= item.weight 
			inv.remove_item(item_id)

			@mgr.render.nearby_entities << item_id
			
			@mgr.ui.inv.set_item_name("")
			@mgr.ui.inv.set_item_desc("")
			@mgr.ui.inv.set_item_qual_cond(-1, -1)
			@mgr.ui.inv.set_item_value(-1)
			@mgr.ui.inv.set_item_weight(-1)

			return true

		end.call

		false

	end


	def use_station(entity)

		pos = @mgr.comp(entity, Position)
		inv = @mgr.comp(entity, Inventory)

		station_id = @mgr.map.get_near_station(pos.x, pos.y) and
		station = @mgr.comp(station_id, Station)             and

		Proc.new do

			vel = @mgr.comp(entity, Velocity)
			vel.spd = 0
			vel.ang_spd = 0
			
			@mgr.paused = !@mgr.paused
			@mgr.ui.toggle = true
			@mgr.time.active = !@mgr.time.active
			@mgr.actions.cur_station = station_id
			@mgr.ui.actions.update_action_info

			return true

		end.call

		false

	end


	def use_door(entity)

		pos = @mgr.comp(entity, Position)
		inv = @mgr.comp(entity, Inventory)

		door_id = @mgr.map.get_near_door(pos.x, pos.y) and
		door = @mgr.comp(door_id, Door)                and
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
