class InputSystem < System

	attr_accessor :user_adapter

	def initialize(mgr)

		@mgr = mgr
		@ctrl = false
		@shift = false
		@user_adapter = UserAdapter.new(self)

	end


	def touch_down(screenX, screenY, pointer, button)

		entities = @mgr.get_all_entities_with(UserInput)
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

							check = pickup_item_at(entity, screenX, screenY)
							
							if !check
								check = use_door_at(entity, screenX, screenY)
							end

							if !check
								# Use workstation
							end
							
						end

					end

				when 1

					if @shift

					elsif @mgr.ui.main_active

						if @mgr.ui.inv_selection
							drop_item(entity)
						end
						
					end

			end

		end
		
		true

	end


	def key_down(keycode)

		entities = @mgr.get_all_entities_with(UserInput)
		entities.each do |entity|

			case keycode

				when Keys::E

					if @shift

					else
						use_door(entity)
					end

				when Keys::C

					if @shift

					else

					end

				when Keys::TAB
					
					if @ctrl

						@mgr.ui.base_update = true
						@mgr.ui.base_active = !@mgr.ui.base_active

					else

						vel = @mgr.get_component(entity, Velocity)
						vel.spd = 0
						vel.ang_spd = 0

						@mgr.ui.main_update = true
						@mgr.paused = !@mgr.paused
						@mgr.ui.main_active = @mgr.paused
						@mgr.time.active = !@mgr.time.active
							
					end

				when Keys::W, Keys::UP

					if @mgr.ui.main_active

						@mgr.ui.actions_update = true
						@mgr.ui.actions_active = !@mgr.ui.actions_active

					else

						vel = @mgr.get_component(entity, Velocity)
						vel.spd = C::PLAYER_SPD

					end

				when Keys::S, Keys::DOWN
					
					if @mgr.ui.main_active

						@mgr.ui.inv_update = true
						@mgr.ui.inv_active = !@mgr.ui.inv_active

					else

						vel = @mgr.get_component(entity, Velocity)
						vel.spd = -C::PLAYER_SPD * 0.5

					end

				when Keys::A, Keys::LEFT

					if @mgr.ui.main_active

						@mgr.ui.equip_update = true
						@mgr.ui.equip_active = !@mgr.ui.equip_active

					else

						vel = @mgr.get_component(entity, Velocity)
						vel.ang_spd = C::PLAYER_ROT_SPD

					end

				when Keys::D, Keys::RIGHT

					if @mgr.ui.main_active

						@mgr.ui.status_update = true
						@mgr.ui.status_active = !@mgr.ui.status_active

					else

						vel = @mgr.get_component(entity, Velocity)
						vel.ang_spd = -C::PLAYER_ROT_SPD

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

		entities = @mgr.get_all_entities_with(UserInput)
		entities.each do |entity|

			case keycode

				when Keys::CONTROL_LEFT, Keys::CONTROL_RIGHT
					
					@ctrl = false
				
				when Keys::SHIFT_LEFT, Keys::SHIFT_RIGHT
					
					@shift = false

				when Keys::W, Keys::S, Keys::UP, Keys::DOWN

					if @mgr.ui.main_active

					else

						vel = @mgr.get_component(entity, Velocity)
						vel.spd = 0

					end

				when Keys::A, Keys::D, Keys::LEFT, Keys::RIGHT

					if @mgr.ui.main_active

					else

						vel = @mgr.get_component(entity, Velocity)
						vel.ang_spd = 0

					end

			end

		end

		true

	end


	def pickup_item(entity)

		pos = @mgr.get_component(entity, Position)
		inv = @mgr.get_component(entity, Inventory)

		item_id = @mgr.map.get_near_item(pos.x, pos.y)

		if item_id && inv.add_item(item_id)

			@mgr.ui.prev_selection = nil
			@mgr.map.remove_item(item_id)
		
		end

	end


	def pickup_item_at(entity, screenX, screenY)

		pos = @mgr.get_component(entity, Position)
		inv = @mgr.get_component(entity, Inventory)

		x = pos.x + C::WTB * (screenX - Gdx.graphics.width/2)
		y = pos.y - C::WTB * (screenY - Gdx.graphics.height/2)

		item_id = @mgr.map.get_item(x, y)					
		dist2 = (x - pos.x)**2 + (y - pos.y)**2

		if item_id && dist2 < 1.4 && inv.add_item(item_id)

			@mgr.ui.prev_selection = nil
			@mgr.map.remove_item(item_id)

		end

	end


	def drop_item(entity)

		pos = @mgr.get_component(entity, Position)
		inv = @mgr.get_component(entity, Inventory)
		rot = @mgr.get_component(entity, Rotation)

		index = @mgr.ui.inv_slots.index(@mgr.ui.inv_selection)
		item_id = inv.items[index]

		if item_id

			item_type = @mgr.get_component(item_id, Type)

			item_pos = Position.new(
				pos.x + rot.x, 
				pos.y + rot.y)

			item_render = Render.new(
				item_type.type,
				@mgr.atlas.find_region(item_type.type))

			item_rot = @mgr.get_component(item_id, Rotation)
			item_rot.angle = rot.angle - 90

			@mgr.add_component(item_id, item_pos)
			@mgr.add_component(item_id, item_render)

			@mgr.map.items << item_id
			inv.remove_item(item_id)
			@mgr.render.nearby_entities << item_id
			@mgr.ui.set_inventory_name("")
			@mgr.ui.set_inventory_desc("")
			@mgr.ui.set_inventory_quality_dur(-1, -1)
			@mgr.ui.set_inventory_value(-1)
			@mgr.ui.set_inventory_weight(-1)
			@mgr.inventory.update_slots = true

		end

	end


	def use_door(entity)

		pos = @mgr.get_component(entity, Position)
		inv = @mgr.get_component(entity, Inventory)

		door_id = @mgr.map.get_near_door(pos.x, pos.y)

		if door_id

			door = @mgr.get_component(door_id, Door)

			if !door.locked

				door.open = !door.open
				@mgr.map.change_door(door_id, door.open)

			end
		
		end

	end


	def use_door_at(entity, screenX, screenY)

		pos = @mgr.get_component(entity, Position)
		inv = @mgr.get_component(entity, Inventory)

		x = pos.x + C::WTB * (screenX - Gdx.graphics.width/2)
		y = pos.y - C::WTB * (screenY - Gdx.graphics.height/2)

		door = @mgr.map.get_door(x, y)
		dist = (x - pos.x)**2 + (y - pos.y)**2
		door = @mgr.get_component(door, Door)

		if door && dist < 2.6 && !door.locked

			door.open = !door.open
			@mgr.map.change_door(door, door.open)

		end

	end


	def dispose

	end

end
