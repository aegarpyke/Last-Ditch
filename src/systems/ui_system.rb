class UISystem < System

	attr_accessor :stage, :inv_slots, :player, :inv_selection, :prev_selection, :inv_no_exit
	attr_accessor :base_selection, :base_no_exit
	attr_accessor :base_active, :main_active, :inv_active, :actions_active, :equip_active, :status_active
	attr_accessor :base_update, :main_update, :inv_update, :actions_update, :equip_update, :status_update

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

		if 1 == 0
			
			@main_table.debug
			@base_table.debug
			@base_table_needs.debug
			@base_table_slots.debug
			@inv_window.debug
			@actions_window.debug
			@status_window.debug
			@equip_window.debug

		end

	end


	def setup_base

		@base_active = true
		@base_update = true

		@base_table = Table.new(@skin)
		@base_table.set_bounds(Gdx.graphics.width - 62, Gdx.graphics.height - 42, 62, 42)

		@base_time = Label.new("", @skin.get("base_ui", LabelStyle.java_class))
		@base_date = Label.new("", @skin.get("base_ui", LabelStyle.java_class))
		@base_money = Label.new("", @skin.get("base_ui", LabelStyle.java_class))
		@base_money.alignment = Align::right
		@base_money.color = Color.new(0.75, 0.82, 0.70, 1)
		@base_weight = Label.new("", @skin.get("base_ui", LabelStyle.java_class))
		@base_weight.color = Color.new(0.75, 0.75, 0.89, 1)
		@base_weight.alignment = Align::right

		@base_table.add(@base_date).align(Align::right).height(11).row
		@base_table.add(@base_time).align(Align::right).height(11).row
		@base_table.add(@base_weight).align(Align::right).height(11).row
		@base_table.add(@base_money).align(Align::right).height(11)

		@base_table_needs = Table.new(@skin)
		@base_table_needs.set_bounds(-3, Gdx.graphics.height - 29, 106, 30)

		@base_hunger = ImageButton.new(@skin.get("status_bars", ImageButtonStyle.java_class))
		@base_hunger.color = Color.new(0.94, 0.35, 0.34, 1)
		@base_thirst = ImageButton.new(@skin.get("status_bars", ImageButtonStyle.java_class))
		@base_thirst.color = Color.new(0.07, 0.86, 0.86, 1)
		@base_energy = ImageButton.new(@skin.get("status_bars", ImageButtonStyle.java_class))
		@base_energy.color = Color.new(0.98, 0.98, 0.04, 1)
		@base_sanity = ImageButton.new(@skin.get("status_bars", ImageButtonStyle.java_class))
		@base_sanity.color = Color.new(0.77, 0.10, 0.87, 1)

		@base_table_needs.add(@base_hunger).width(106).padTop(0).height(7).row
		@base_table_needs.add(@base_thirst).width(106).padTop(0).height(7).row
		@base_table_needs.add(@base_energy).width(106).padTop(0).height(7).row
		@base_table_needs.add(@base_sanity).width(106).padTop(0).height(7)

		@base_selection = nil
		@base_no_exit = false
		@base_table_slots = Table.new(@skin)
		@base_table_slots.set_bounds(0, 0, Gdx.graphics.width, 32)

		@base_slots = []
		for i in 1..C::BASE_SLOTS
			
			@base_slots << ImageButton.new(@skin.get("base_slot", ImageButtonStyle.java_class))
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

						true

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
		
		setup_actions
		setup_equipment
		setup_status
		setup_inventory

		@main_active = false
		@main_update = true

		@main_table = Table.new(@skin)
		@main_table.set_bounds(0, 0, Gdx.graphics.width, Gdx.graphics.height)

		@main_table.add(@actions_button).width(90).height(14).colspan(2).padBottom(100).row
		@main_table.add(@equip_button).width(90).height(14).padTop(24).padRight(340).padBottom(24).padRight(60)
		@main_table.add(@status_button).width(90).height(14).padTop(24).padLeft(340).padBottom(24).row
		@main_table.add(@inv_button).width(90).height(14).padTop(100).colspan(2)

	end


	def setup_actions

		@actions_active = false
		@actions_button = TextButton.new("Actions", @skin.get(TextButtonStyle.java_class))
		@actions_button.add_listener(

			Class.new(ClickListener) do

				def initialize(mgr, ui)
					super()
					@ui = ui
					@mgr = mgr
				end

				def clicked(event, x, y)
					@ui.actions_update = true
					@ui.actions_active = !@ui.actions_active
				end

			end.new(@mgr, self))

		@actions_window = Window.new("Actions", @skin.get(WindowStyle.java_class))
		@actions_window.set_position(128, 352)
		@actions_window.set_size(544, 240)
		@actions_window.movable = false
		@actions_window.padTop(9)

	end


	def setup_equipment

		@equip_active = false
		@equip_button = TextButton.new("Equipment", @skin.get(TextButtonStyle.java_class))
		@equip_button.add_listener(

			Class.new(ClickListener) do
			
				def initialize(mgr, ui)
					super()
					@ui = ui
					@mgr = mgr
				end

				def clicked(event, x, y)
					@ui.equip_update = true
					@ui.equip_active = !@ui.equip_active
				end
		
			end.new(@mgr, self))

		@equip_window = Window.new("Equipment", @skin.get(WindowStyle.java_class))
		@equip_window.set_position(0, 44)
		@equip_window.set_size(250, 290)
		@equip_window.movable = false
		@equip_window.padTop(9)

		@equip_head = Image.new(@atlas.find_region('equip_head'))
		@equip_l_arm = Image.new(@atlas.find_region('equip_arm'))
		@equip_torso = Image.new(@atlas.find_region('equip_torso'))
		r_arm_tex = TextureRegion.new(@atlas.find_region('equip_arm'))
		r_arm_tex.flip(true, false)
		@equip_r_arm = Image.new(r_arm_tex)
		@equip_l_hand = Image.new(@atlas.find_region('equip_hand'))
		@equip_belt = Image.new(@atlas.find_region('equip_belt'))
		r_hand_tex = TextureRegion.new(@atlas.find_region('equip_hand'))
		r_hand_tex.flip(true, false)
		@equip_r_hand = Image.new(r_hand_tex)
		@equip_l_leg = Image.new(@atlas.find_region('equip_leg'))
		@equpi_leg_spacer = Image.new(@atlas.find_region('empty'))
		r_leg_tex = TextureRegion.new(@atlas.find_region('equip_leg'))
		r_leg_tex.flip(true, false)
		@equip_r_leg = Image.new(r_leg_tex)
		@equip_l_foot = Image.new(@atlas.find_region('equip_foot'))
		@equip_foot_spacer = Image.new(@atlas.find_region('empty'))
		r_foot_tex = TextureRegion.new(@atlas.find_region('equip_foot'))
		r_foot_tex.flip(true, false)
		@equip_r_foot = Image.new(r_foot_tex)

		@equip_window.add(@equip_head).colspan(3).row
		@equip_window.add(@equip_l_arm)
		@equip_window.add(@equip_torso)
		@equip_window.add(@equip_r_arm).row
		@equip_window.add(@equip_l_hand)
		@equip_window.add(@equip_belt)
		@equip_window.add(@equip_r_hand).row
		@equip_window.add(@equip_l_leg)
		@equip_window.add(@equpi_leg_spacer)
		@equip_window.add(@equip_r_leg).row
		@equip_window.add(@equip_l_foot)
		@equip_window.add(@equip_foot_spacer)
		@equip_window.add(@equip_r_foot).row

	end


	def setup_status

		@status_active = false
		@status_button = TextButton.new("Status", @skin.get(TextButtonStyle.java_class))
		@status_button.add_listener(

			Class.new(ClickListener) do
			
				def initialize(mgr, ui)
					super()
					@ui = ui
					@mgr = mgr
				end

				def clicked(event, x, y)
					@ui.status_update = true
					@ui.status_active = !@ui.status_active
				end

			end.new(@mgr, self))

		@status_window = Window.new("Status", @skin.get(WindowStyle.java_class))
		@status_window.set_position(560, 44)
		@status_window.set_size(250, 290)
		@status_window.movable = false
		@status_window.padTop(9)

		info = @mgr.comp(@player, Info)

		@status_name = Label.new("Name: %s" % info.name, @skin.get("inv_slot", LabelStyle.java_class))
		@status_window.add(@status_name).align(Align::left).height(14).row
		@status_occupation = Label.new("Unemployed", @skin.get("inv_slot", LabelStyle.java_class))
		@status_window.add(@status_occupation).align(Align::left).height(11).row

	end


	def setup_inventory

		@inv_active = false
		@inv_no_exit = false

		@inv_button = TextButton.new("Inventory", @skin.get(TextButtonStyle.java_class))
		@inv_listener = @inv_button.add_listener(

			Class.new(ClickListener) do
			
				def initialize(mgr, ui)
					super()
					@ui = ui
					@mgr = mgr
				end

				def clicked(event, x, y)
					@ui.inv_update = true
					@ui.inv_active = !@ui.inv_active
				end

			end.new(@mgr, self))

		@inv_window = Window.new("Inventory", @skin.get(WindowStyle.java_class))
		@inv_window.set_position(268, 2)
		@inv_window.set_size(268, 236)
		@inv_window.movable = false
		@inv_window.padTop(9)

		@inv_item_name = Label.new("", @skin.get("inv_slot", LabelStyle.java_class))
		@inv_window.add(@inv_item_name).colspan(4).align(Align::left).padTop(4).height(12)
		
		@inv_item_value = Label.new("", @skin.get("inv_slot", LabelStyle.java_class))
		@inv_item_value.color = Color.new(0.75, 0.82, 0.70, 1.0)
		@inv_window.add(@inv_item_value).colspan(4).align(Align::right).padTop(4).height(14).row

		@inv_item_weight = Label.new("", @skin.get("inv_slot", LabelStyle.java_class))
		@inv_item_weight.color = Color.new(0.75, 0.75, 0.89, 1.0)
		@inv_window.add(@inv_item_weight).colspan(4).align(Align::left).height(14).padTop(1)

		@inv_item_quality_dur = Label.new("", @skin.get("inv_slot", LabelStyle.java_class))
		@inv_item_quality_dur.color = Color.new(0.8, 0.8, 0.8, 1.0)
		@inv_window.add(@inv_item_quality_dur).colspan(4).align(Align::right).padTop(1).height(12).row

		@inv_desc = ""

		@inv_item_desc1 = Label.new('', @skin.get("inv_slot", LabelStyle.java_class))
		@inv_window.add(@inv_item_desc1).align(Align::left).padLeft(8).padTop(6).colspan(8).height(12).row
		@inv_item_desc2 = Label.new('', @skin.get("inv_slot", LabelStyle.java_class))
		@inv_window.add(@inv_item_desc2).align(Align::left).padLeft(5).colspan(8).height(12).row
		@inv_item_desc3 = Label.new('', @skin.get("inv_slot", LabelStyle.java_class))
		@inv_window.add(@inv_item_desc3).align(Align::left).padLeft(5).colspan(8).height(12).row

		set_inv_desc(@inv_desc)

		@inv_slots = []
		for i in 1..C::INVENTORY_SLOTS
			
			@inv_slots << ImageButton.new(@skin.get("inv_slot", ImageButtonStyle.java_class))
			@inv_slots.last.add_listener(

				Class.new(ClickListener) do
				
					def initialize(mgr, slot, atlas, ui)

						super()
						@ui = ui
						@mgr = mgr
						@slot = slot
						@atlas = atlas
					
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

					def touchUp(event, x, y, pointer, button)
						
					end


					def clicked(event, x, y)

						@mgr.ui.inv_no_exit = true

						inv = @mgr.comp(@ui.player, Inventory)

						index = @ui.inv_slots.index(@slot)
						item = inv.items[index]

						type = @mgr.comp(item, Type)

						true
						
					end

				end.new(@mgr, @inv_slots.last, @atlas, self))

			if i % 8 == 0
				@inv_window.add(@inv_slots.last).pad(0).row
			else
				@inv_window.add(@inv_slots.last).pad(0)
			end

		end


	end


	def set_inv_qual_cond(quality, condition)
		
		unless quality == -1 && condition == -1
			@inv_item_quality_dur.text = "Qual-%d Cond-%d" % [(quality * 100).to_i, (condition * 100).to_i]
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

		@inv_desc_lines = desc.scan(/.{1,46}\b|.{1,46}/).map(&:strip)

		while @inv_desc_lines.size < 3
			@inv_desc_lines << ""
		end

		@inv_item_desc1.text = @inv_desc_lines[0]
		@inv_item_desc2.text = @inv_desc_lines[1]
		@inv_item_desc3.text = @inv_desc_lines[2]

	end


	def update

		if @base_active

			needs = @mgr.comp(@player, Needs)
			inv = @mgr.comp(@player, Inventory)

			@base_time.text = @mgr.time.time
			@base_date.text = @mgr.time.date
			@base_money.text = "$%.2f" % inv.money
			@base_weight.text = "%.1fkg" % inv.weight

			@base_hunger.width = (needs.hunger * 100 + 4).to_i
			@base_thirst.width = (needs.thirst * 100 + 4).to_i
			@base_energy.width = (needs.energy * 100 + 4).to_i
			@base_sanity.width = (needs.sanity * 100 + 4).to_i

			if @inv_selection != @prev_selection

				if @inv_selection

					index = @inv_slots.index(@inv_selection)
					item_id = inv.items[index]

					if item_id

						item = @mgr.comp(item_id, Item)
						info = @mgr.comp(item_id, Info)

						set_inv_name(info.name)
						set_inv_qual_cond(item.quality, item.condition)
						set_inv_value(item.value)
						set_inv_weight(item.weight)
						set_inv_desc(info.description)

					else

						set_inv_name("")
						set_inv_qual_cond(-1, -1)
						set_inv_value(-1)
						set_inv_weight(-1)
						set_inv_desc("")

					end

				else

					set_inv_name("")
					set_inv_qual_cond(-1, -1)
					set_inv_value(-1)
					set_inv_weight(-1)
					set_inv_desc("")

				end

			end

			@prev_selection = @inv_selection

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