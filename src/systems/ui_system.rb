class UISystem < System

	attr_accessor :player, :stage
	attr_accessor :main_active, :main_update
	attr_accessor :base_active, :base_update, :base_selection, :base_no_exit
	attr_accessor :inv_active, :inv_update, :inv_selection, :inv_prev_selection, :inv_slots, :inv_no_exit
	attr_accessor :actions_active, :equip_active, :status_active
	attr_accessor :actions_update, :equip_update, :status_update
 
	def initialize(mgr, player, atlas)

		super()
		@mgr = mgr
		@mgr.ui = self
		@atlas = atlas
		@player = player
		@stage = Stage.new
		@skin = Skin.new(Gdx.files.internal('cfg/uiskin.json'), @atlas)

		setup_base
		setup_main

		if 1 == 1
			
			# @main_table.debug
			@base_table.debug
			@base_table_needs.debug
			@base_table_slots.debug
			@status_table_model.debug
			@inv_window.debug
			@actions_window.debug
			@actions_left.debug
			@actions_right.debug
			@status_window.debug
			@equip_window.debug

		end

	end


	def setup_base

		@base_active = true
		@base_update = true

		base_w, base_h = 62, 42
		@base_table = Table.new(@skin)
		@base_table.set_bounds(
			C::WIDTH - base_w, 
			C::HEIGHT - base_h, 
			base_w, base_h)

		@base_time = Label.new("", @skin, "base_ui")
		@base_date = Label.new("", @skin, "base_ui")
		@base_money = Label.new("", @skin, "base_ui")
		@base_money.set_alignment(Align::right)
		@base_money.set_color(Color.new(0.75, 0.82, 0.70, 1))
		@base_weight = Label.new("", @skin, "base_ui")
		@base_weight.set_color(Color.new(0.75, 0.75, 0.89, 1))
		@base_weight.set_alignment(Align::right)

		@base_table.add(@base_date).align(Align::right).height(11).row
		@base_table.add(@base_time).align(Align::right).height(11).row
		@base_table.add(@base_weight).align(Align::right).height(11).row
		@base_table.add(@base_money).align(Align::right).height(11)

		@base_table_needs = Table.new(@skin)
		@base_table_needs.set_bounds(-3, C::HEIGHT - 29, 106, 30)

		@base_hunger = ImageButton.new(@skin, "status_bars")
		@base_hunger.set_color(Color.new(0.94, 0.35, 0.34, 1))
		@base_thirst = ImageButton.new(@skin, "status_bars")
		@base_thirst.set_color(Color.new(0.07, 0.86, 0.86, 1))
		@base_energy = ImageButton.new(@skin, "status_bars")
		@base_energy.set_color(Color.new(0.98, 0.98, 0.04, 1))
		@base_sanity = ImageButton.new(@skin, "status_bars")
		@base_sanity.set_color(Color.new(0.77, 0.10, 0.87, 1))

		@base_table_needs.add(@base_hunger).width(106).padTop(0).height(7).row
		@base_table_needs.add(@base_thirst).width(106).padTop(0).height(7).row
		@base_table_needs.add(@base_energy).width(106).padTop(0).height(7).row
		@base_table_needs.add(@base_sanity).width(106).padTop(0).height(7)

		@base_selection = nil
		@base_no_exit = false
		@base_table_slots = Table.new(@skin)
		@base_table_slots.set_bounds(0, 0, C::WIDTH, 32)

		@base_slots = []
		for i in 1..C::BASE_SLOTS
			
			@base_slots << ImageButton.new(@skin, "base_slot")
			@base_slots.last.add_listener(

				Class.new(ClickListener) do
				
					def initialize(mgr, slot, atlas, ui)

						super()
						@ui = ui
						@mgr = mgr
						@slot = slot
						@atlas = atlas
					
					end


					def enter(event, x, y, pointer, from_actor)

						@ui.base_selection = @slot

						style = ImageButtonStyle.new(@ui.base_selection.style)
						style.up = TextureRegionDrawable.new(@atlas.find_region('base_selection'))
						@ui.base_selection.style = style

						true

					end


					def exit(event, x, y, pointer, to_actor)

						if @mgr.ui.base_no_exit

							@mgr.ui.base_no_exit = false

						else

							@ui.base_selection = nil

							style = ImageButtonStyle.new(@slot.style)
							style.up = TextureRegionDrawable.new(@atlas.find_region('base_slot'))
							@slot.style = style

						end

						true

					end


					def clicked(event, x, y)
						@mgr.ui.base_no_exit = true
					end

				end.new(@mgr, @base_slots.last, @atlas, self))

			if i < 9
				@base_table_slots.add(@base_slots.last).align(Align::left)
			elsif i == 9
				@base_table_slots.add(@base_slots.last).align(Align::right).padLeft(286)
			else
				@base_table_slots.add(@base_slots.last).align(Align::right)
			end

		end

	end


	def setup_main
		
		@main_active = false
		@main_update = true

		@main_table = Table.new(@skin)
		@main_table.set_bounds(0, 0, C::WIDTH, C::HEIGHT)
		
		setup_actions
		setup_equipment
		setup_status
		setup_inventory

	end


	def setup_actions

		@actions_active = true

		@actions_window = Window.new(
			"Actions", @skin, "window1")
		@actions_window.set_position(128, 342)
		@actions_window.set_size(548, 254)
		@actions_window.set_movable(false)
		@actions_window.padTop(9)

		@actions_left = Table.new
		@actions_left.align(Align::left | Align::top)

		@actions_crafting_button = TextButton.new(
			"Crafting", @skin, "actions_button")
		@actions_object_button = TextButton.new(
			"Object", @skin, "actions_button")

		@actions_crafting_button.add_listener(

			Class.new(ClickListener) do 

				def initialize(crafting_button, object_button)

					super()
					@crafting_button = crafting_button
					@object_button = object_button
				
				end

				def clicked(event, x, y)
				
					@crafting_button.set_checked(true)
					@object_button.set_checked(false)
				
				end

			end.new(@actions_crafting_button, @actions_object_button))

		@actions_object_button.add_listener(

			Class.new(ClickListener) do 

				def initialize(crafting_button, object_button)
				
					super()
					@crafting_button = crafting_button
					@object_button = object_button
				
				end

				def clicked(event, x, y)
				
					@crafting_button.set_checked(false)
					@object_button.set_checked(true)
				
				end

			end.new(@actions_crafting_button, @actions_object_button))

		@actions_crafting_list = List.new(@skin, "actions")
		collect = com.badlogic.gdx.utils.Array.new

		for i in 0...16
			collect.add("%s Testing %s" % [i, i])
		end

		for i in 16..32
			collect.add("")
		end

		@actions_crafting_list.set_items(collect)


		@actions_object_list = List.new(@skin, "actions")

		@actions_crafting_scrollpane = ScrollPane.new(@actions_crafting_list, @skin, "actions")
		@actions_crafting_scrollpane.set_overscroll(false, false)

		@actions_object_scrollpane = ScrollPane.new(@actions_object_list, @skin, "actions")


		@actions_left.add(@actions_crafting_button).height(15).padRight(9)
		@actions_left.add(@actions_object_button).height(15).row
		@actions_left.add(@actions_crafting_scrollpane)


		@actions_right = Table.new
		@actions_right.align(Align::left | Align::top)

		@actions_name = Label.new("Name", @skin, "actions")
		@actions_station_label = Label.new("Station:", @skin, "actions")

		@actions_right.add(@actions_name).padLeft(8).align(Align::left).row
		@actions_right.add(@actions_station_label).padLeft(8).align(Align::left)

		@actions_split = SplitPane.new(
			@actions_left, @actions_right,
			false, @skin, "actions_split_pane")

		@actions_window.add(@actions_split).width(540).height(234).padTop(10)

	end


	def setup_equipment

		@equip_active = true

		@equip_window = Window.new("Equipment", @skin, "window1")
		@equip_window.set_position(0, 44)
		@equip_window.set_size(250, 290)
		@equip_window.set_movable(false)
		@equip_window.padTop(9)
		@equip_window.align(Align::center)
		
		@equip_l_head_label = Label.new("Endex", @skin, "equip")
		@equip_r_head_label = Label.new("Ear piece", @skin, "equip")
		@equip_l_arm_label  = Label.new("Empty", @skin, "equip")
		@equip_torso_label  = Label.new("Flak jacket", @skin, "equip")
		@equip_r_arm_label  = Label.new("GPS Device", @skin, "equip")
		@equip_l_hand_label = Label.new("Empty", @skin, "equip")
		@equip_belt_label   = Label.new("Engineer's belt", @skin, "equip")
		@equip_r_hand_label = Label.new("Handgun", @skin, "equip")
		@equip_l_leg_label  = Label.new("Kneepads", @skin, "equip")
		@equip_r_leg_label  = Label.new("Kneepads", @skin, "equip")
		@equip_l_foot_label = Label.new("Athletic shoes", @skin, "equip")
		@equip_r_foot_label = Label.new("Athletic shoes", @skin, "equip")

		@equip_l_head_label.set_alignment(Align::center)
		@equip_r_head_label.set_alignment(Align::center)
		@equip_l_arm_label .set_alignment(Align::center)
		@equip_torso_label .set_alignment(Align::center)
		@equip_r_arm_label .set_alignment(Align::center)
		@equip_l_hand_label.set_alignment(Align::center)
		@equip_belt_label  .set_alignment(Align::center)
		@equip_r_hand_label.set_alignment(Align::center)
		@equip_l_leg_label .set_alignment(Align::center)
		@equip_r_leg_label .set_alignment(Align::center)
		@equip_l_foot_label.set_alignment(Align::center)
		@equip_r_foot_label.set_alignment(Align::center)

		@equip_desc = Label.new(
			"This is a description of whatever it is that needs to be described. "\
			"The act of describing something worth a description is a worthwhile "\
			"act, and therefore this act also merits a description. This "\
			"description is that description.",
			@skin, "equip")
		@equip_desc.set_wrap(true)

		equip_label_size = 120

		@equip_window.add(@equip_l_head_label).width(equip_label_size).padRight(0)
		@equip_window.add(@equip_r_head_label).width(equip_label_size).row
		@equip_window.add(@equip_l_arm_label).width(equip_label_size).padRight(0)
		@equip_window.add(@equip_r_arm_label).width(equip_label_size).row
		@equip_window.add(@equip_torso_label).width(equip_label_size).colspan(2).row
		@equip_window.add(@equip_l_hand_label).width(equip_label_size).padRight(0)
		@equip_window.add(@equip_r_hand_label).width(equip_label_size).row
		@equip_window.add(@equip_belt_label).width(equip_label_size).colspan(2).row
		@equip_window.add(@equip_l_leg_label).width(equip_label_size).padRight(0)
		@equip_window.add(@equip_r_leg_label).width(equip_label_size).row
		@equip_window.add(@equip_l_foot_label).width(equip_label_size).padRight(0)
		@equip_window.add(@equip_r_foot_label).width(equip_label_size).row
		@equip_window.add(@equip_desc).colspan(3).width(240)

	end


	def setup_status

		@status_active = true

		@status_window = Window.new("Status", @skin, "window1")
		@status_window.set_position(560, 44)
		@status_window.set_size(250, 290)
		@status_window.movable = false
		@status_window.padTop(9)

		@status_table_model = Table.new(@skin)

		info = @mgr.comp(@player, Info)

		r_head_tex = TextureRegion.new(@atlas.find_region('status_head'))
		r_arm_tex  = TextureRegion.new(@atlas.find_region('status_arm'))
		r_hand_tex = TextureRegion.new(@atlas.find_region('status_hand'))
		r_leg_tex  = TextureRegion.new(@atlas.find_region('status_leg'))
		r_foot_tex = TextureRegion.new(@atlas.find_region('status_foot'))

		r_head_tex.flip(true, false)
		r_arm_tex.flip(true, false)
		r_hand_tex.flip(true, false)
		r_leg_tex.flip(true, false)
		r_foot_tex.flip(true, false)

		@status_name = Label.new(
			"Name: %s" % info.name, @skin, "status")
		@status_occupation = Label.new(
			"Occupation: %s" % info.occupation, @skin, "status")

		@status_l_head = Image.new(@atlas.find_region('status_head'))
		@status_r_head = Image.new(r_head_tex)
		@status_l_arm  = Image.new(@atlas.find_region('status_arm'))
		@status_torso  = Image.new(@atlas.find_region('status_torso'))
		@status_r_arm  = Image.new(r_arm_tex)
		@status_l_hand = Image.new(@atlas.find_region('status_hand'))
		@status_r_hand = Image.new(r_hand_tex)
		@status_l_leg  = Image.new(@atlas.find_region('status_leg'))
		@status_r_leg  = Image.new(r_leg_tex)
		@status_l_foot = Image.new(@atlas.find_region('status_foot'))
		@status_r_foot = Image.new(r_foot_tex)

		@status_add_info = Label.new(
			"Additional Info\n"\
			"Additional Info\n"\
			"Additional Info\n"\
			"Additional Info\n"\
			"Additional Info",
			@skin, "status")
		@status_add_info.wrap = true

		@status_window.add(@status_name).width(246).height(14).padLeft(4).colspan(4).align(Align::left).row
		@status_window.add(@status_occupation).height(11).colspan(4).padLeft(4).padBottom(12).align(Align::left).row
		
		@status_table_model.add(@status_l_head).width(13).height(34).padLeft(39).padBottom(3).colspan(2)
		@status_table_model.add(@status_r_head).width(13).height(34).padRight(39).padBottom(3).colspan(2).row
		@status_table_model.add(@status_l_arm).width(28).height(51).padRight(-7).padLeft(0).padTop(0).colspan(1)
		@status_table_model.add(@status_torso).width(39).height(47).padTop(-2).colspan(2)
		@status_table_model.add(@status_r_arm).width(28).height(51).padRight(0).padLeft(-7).padTop(0).colspan(1).row
		@status_table_model.add(@status_l_hand).width(14).height(14).padRight(14).padTop(-5).padBottom(28).colspan(1)
		@status_table_model.add(@status_l_leg).width(24).height(47).padRight(0).padTop(-2).colspan(1)
		@status_table_model.add(@status_r_leg).width(24).height(47).padLeft(0).padTop(-2).colspan(1)
		@status_table_model.add(@status_r_hand).width(14).height(14).padLeft(14).padTop(-5).padBottom(28).colspan(1).row
		@status_table_model.add(@status_l_foot).width(24).height(13).colspan(2).padTop(2).padLeft(18).padRight(7)
		@status_table_model.add(@status_r_foot).width(24).height(13).colspan(2).padTop(2).padLeft(7).padRight(18).row

		@status_window.add(@status_table_model).width(117).height(140).padLeft(4).align(Align::left).row
		@status_window.add(@status_add_info).width(246).padTop(8).padLeft(4)

		@status_l_head.color = Color.new(1.00, 0.50, 0.50, 1.0)
		@status_r_head.color = Color.new(1.00, 1.00, 1.00, 1.0)
		@status_l_arm.color  = Color.new(1.00, 1.00, 1.00, 1.0)
		@status_torso.color  = Color.new(1.00, 1.00, 1.00, 1.0)
		@status_r_arm.color  = Color.new(1.00, 0.40, 0.40, 1.0)
		@status_l_hand.color = Color.new(1.00, 1.00, 1.00, 1.0)
		@status_l_leg.color  = Color.new(1.00, 1.00, 1.00, 1.0)
		@status_r_leg.color  = Color.new(1.00, 1.00, 1.00, 1.0)
		@status_r_hand.color = Color.new(1.00, 1.00, 1.00, 1.0)
		@status_l_foot.color = Color.new(1.00, 0.20, 0.20, 1.0)
		@status_r_foot.color = Color.new(1.00, 1.00, 1.00, 1.0)

	end


	def setup_inventory

		@inv_active = true
		@inv_no_exit = false

		@inv_item_name = Label.new("", @skin, "inv")
		@inv_item_value = Label.new("", @skin, "inv")
		@inv_item_value.color = Color.new(0.75, 0.82, 0.70, 1.0)
		@inv_item_weight = Label.new("", @skin, "inv")
		@inv_item_weight.color = Color.new(0.75, 0.75, 0.89, 1.0)
		@inv_item_quality_dur = Label.new("", @skin, "inv")
		@inv_item_quality_dur.color = Color.new(0.8, 0.8, 0.8, 1.0)
		@inv_item_desc = Label.new("", @skin, "inv")
		@inv_item_desc.alignment = Align::top | Align::left
		@inv_item_desc.wrap = true

		@inv_window = Window.new("Inventory", @skin, "window1")
		@inv_window.set_position(262, 2)
		@inv_window.set_size(276, 236)
		@inv_window.movable = false
		@inv_window.padTop(9)

		@inv_window.add(@inv_item_name).colspan(4).align(Align::left).padTop(4).height(12)
		@inv_window.add(@inv_item_value).colspan(4).align(Align::right).padTop(4).height(14).row
		@inv_window.add(@inv_item_weight).colspan(4).align(Align::left).height(14).padTop(1)
		@inv_window.add(@inv_item_quality_dur).colspan(4).align(Align::right).padTop(1).height(12).row
		@inv_window.add(@inv_item_desc).colspan(8).width(256).height(62).row

		@inv_slots = []
		for i in 1..C::INVENTORY_SLOTS
			
			@inv_slots << ImageButton.new(@skin, "inv_slot")
			@inv_slots.last.add_listener(

				Class.new(ClickListener) do
				
					def initialize(mgr, slot, atlas, player, ui)

						super()
						@ui = ui
						@mgr = mgr
						@slot = slot
						@atlas = atlas
						@player = player
					
					end


					def enter(event, x, y, pointer, from_actor)

						@ui.inv_selection = @slot

						style = ImageButtonStyle.new(@ui.inv_selection.style)
						style.up = TextureRegionDrawable.new(@atlas.find_region('inv_selection'))
						@ui.inv_selection.style = style

						true

					end


					def exit(event, x, y, pointer, to_actor)

						if @mgr.ui.inv_no_exit

							@mgr.ui.inv_no_exit = false

						else

							@ui.inv_selection = nil

							style = ImageButtonStyle.new(@slot.style)
							style.up = TextureRegionDrawable.new(@atlas.find_region('inv_slot'))
							@slot.style = style

						end

						true

					end


					def clicked(event, x, y)

						@mgr.ui.inv_no_exit = true
						@ui.use_item

					end

				end.new(@mgr, @inv_slots.last, @atlas, @player, self))

			if i % 8 == 0
				@inv_window.add(@inv_slots.last).pad(0).row
			else
				@inv_window.add(@inv_slots.last).pad(0)
			end

		end


	end


	def use_item

		@inv_selection                           and
		index = @inv_slots.index(@inv_selection) and
		inv = @mgr.comp(@player, Inventory)      and
		item_id = inv.items[index]               and
		item = @mgr.comp(item_id, Item)          and
		item.usable                              and

		Proc.new do

			@mgr.inventory.update_slots = true

			type = @mgr.comp(item_id, Type)
			info = @mgr.comp(item_id, Info)

			@mgr.inventory.use_item(@player, item_id, type.type)

			set_inv_name(info.name)
			set_inv_desc(info.desc)
			set_inv_qual_cond(item.quality, item.condition)
			set_inv_value(item.value)
			set_inv_weight(item.weight)

			return true

		end.call
	
		false

	end


	def set_inv_qual_cond(quality, condition)
		
		unless quality == -1 && condition == -1
			@inv_item_quality_dur.text = "Q-%d C-%d" % [(quality * 100).to_i, (condition * 100).to_i]
		else
			@inv_item_quality_dur.text = ""
		end
	end


	def set_inv_value(value)

		unless value == -1
			@inv_item_value.text = "$%.2f" % value
		else
			@inv_item_value.text = ""
		end

	end


	def set_inv_weight(weight)

		unless weight == -1
			@inv_item_weight.text = " %.1fkg" % weight
		else
			@inv_item_weight.text = ""
		end

	end


	def set_inv_name(name)
		@inv_item_name.text = name
	end


	def set_inv_desc(desc)
		@inv_item_desc.text = desc
	end


	def reset_inv_info

		set_inv_name("")
		set_inv_qual_cond(-1, -1)
		set_inv_value(-1)
		set_inv_weight(-1)
		set_inv_desc("")

	end


	def update

		if @base_active

			needs = @mgr.comp(@player, Needs)
			inv = @mgr.comp(@player, Inventory)

			@base_time.text   = @mgr.time.time
			@base_date.text   = @mgr.time.date
			@base_money.text  = "$%.2f" % inv.money
			@base_weight.text = "%.1fkg" % inv.weight

			@base_hunger.width = (needs.hunger * 100 + 4).to_i
			@base_thirst.width = (needs.thirst * 100 + 4).to_i
			@base_energy.width = (needs.energy * 100 + 4).to_i
			@base_sanity.width = (needs.sanity * 100 + 4).to_i

			if @inv_selection != @inv_prev_selection

				if @inv_selection

					index = @inv_slots.index(@inv_selection)

					if item_id = inv.items[index]

						item = @mgr.comp(item_id, Item)
						info = @mgr.comp(item_id, Info)

						set_inv_name(info.name)
						set_inv_qual_cond(item.quality, item.condition)
						set_inv_value(item.value)
						set_inv_weight(item.weight)
						set_inv_desc(info.desc)

					else

						reset_inv_info

					end

				else

					reset_inv_info

				end

			end

			@inv_prev_selection = @inv_selection

		end

		if @base_update

			@base_update = false

			if @base_active

				@stage.add_actor(@base_table)
				@stage.add_actor(@base_table_needs)
				@stage.add_actor(@base_table_slots)
			
			else
			
				@base_table.remove
				@base_table_needs.remove
				@base_table_slots.remove
			
			end
		
		end

		if @main_update

			@main_update = false

			if @main_active

				@stage.add_actor(@main_table)
				@stage.add_actor(@actions_window) if @actions_active
				@stage.add_actor(@inv_window) if @inv_active
				@stage.add_actor(@equip_window) if @equip_active
				@stage.add_actor(@status_window) if @status_active
			
			else
			
				@main_table.remove
				@actions_window.remove
				@inv_window.remove
				@equip_window.remove
				@status_window.remove

			end
		
		end

		if @inv_update

			@inv_update = false

			if @inv_active
				@stage.add_actor(@inv_window)
			else
				@inv_window.remove
			end

		end

		if @status_update

			@status_update = false

			if @status_active
				@stage.add_actor(@status_window)
			else
				@status_window.remove
			end

		end

		if @actions_update

			@actions_update = false

			if @actions_active
				@stage.add_actor(@actions_window)
			else
				@actions_window.remove
			end

		end

		if @equip_update

			@equip_update = false

			if @equip_active
				@stage.add_actor(@equip_window)
			else
				@equip_window.remove
			end

		end

	end


	def render

		if @main_active || @base_active

			@stage.act
			@stage.draw

			Table.draw_debug(@stage)

		end

	end


	def dispose


	end

end