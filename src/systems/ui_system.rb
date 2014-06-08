class UISystem < System

	attr_accessor :stage, :inv_slots, :player, :inv_selection, :prev_selection
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
		@base_table.set_bounds(Gdx.graphics.width - 66, Gdx.graphics.height - 32, 66, 32)

		@base_time = Label.new("", @skin.get("base_ui", LabelStyle.java_class))
		@base_date = Label.new("", @skin.get("base_ui", LabelStyle.java_class))
		@base_money = Label.new("", @skin.get("base_ui", LabelStyle.java_class))
		@base_money.color = Color.new(0.75, 0.82, 0.70, 1.0)

		@base_table.add(@base_date).align(Align::right).height(11).row
		@base_table.add(@base_time).align(Align::right).height(11).row
		@base_table.add(@base_money).align(Align::right).height(11)

		@base_table_needs = Table.new(@skin)
		@base_table_needs.set_bounds(-2, Gdx.graphics.height - 30, 106, 30)

		@base_hunger = ImageButton.new(@skin.get("status_bars", ImageButtonStyle.java_class))
		@base_hunger.color = Color.new(0.94, 0.35, 0.34, 1.0)
		@base_thirst = ImageButton.new(@skin.get("status_bars", ImageButtonStyle.java_class))
		@base_thirst.color = Color.new(0.07, 0.86, 0.86, 1.0)
		@base_energy = ImageButton.new(@skin.get("status_bars", ImageButtonStyle.java_class))
		@base_energy.color = Color.new(0.98, 0.98, 0.04, 1.0)
		@base_sanity = ImageButton.new(@skin.get("status_bars", ImageButtonStyle.java_class))
		@base_sanity.color = Color.new(0.77, 0.10, 0.87, 1.0)

		@base_table_needs.add(@base_hunger).width(106).padTop(-2).height(8).row
		@base_table_needs.add(@base_thirst).width(106).padTop(-2).height(8).row
		@base_table_needs.add(@base_energy).width(106).padTop(-2).height(8).row
		@base_table_needs.add(@base_sanity).width(106).padTop(-2).height(8)

	end


	def setup_main

		@main_active = false
		@main_update = true

		@main_table = Table.new(@skin)
		@main_table.set_bounds(0, 0, Gdx.graphics.width, Gdx.graphics.height)

		setup_actions
		setup_equipment
		setup_status
		setup_inventory

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
		@actions_window.set_position(340, 400)
		@actions_window.padTop(9)

		@main_table.add(@actions_button).width(90).height(14).colspan(2).row

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
		@equip_window.set_position(12, 260)
		@equip_window.padTop(9)

		@main_table.add(@equip_button).width(90).height(14).padTop(24).padBottom(24).padRight(60)

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
		@status_window.set_position(500, 260)
		@status_window.padTop(9)

		@main_table.add(@status_button).width(90).height(14).padTop(24).padBottom(24).row

	end


	def setup_inventory

		@inv_active = false
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
		@inv_window.set_position(280, 4)
		@inv_window.set_size(288, 236)
		@inv_window.padTop(9)

		@inv_item_name = Label.new("", @skin.get("inv_slot", LabelStyle.java_class))
		@inv_window.add(@inv_item_name).colspan(8).align(Align::left).padLeft(2).padTop(8).padBottom(2).height(12).row

		@inv_desc = ""

		@inv_item_desc1 = Label.new('', @skin.get("inv_slot", LabelStyle.java_class))
		@inv_window.add(@inv_item_desc1).align(Align::left).padLeft(8).colspan(8).height(12).row
		@inv_item_desc2 = Label.new('', @skin.get("inv_slot", LabelStyle.java_class))
		@inv_window.add(@inv_item_desc2).align(Align::left).padLeft(5).colspan(8).height(12).row
		@inv_item_desc3 = Label.new('', @skin.get("inv_slot", LabelStyle.java_class))
		@inv_window.add(@inv_item_desc3).align(Align::left).padLeft(5).colspan(8).height(12).row
		@inv_item_desc4 = Label.new('', @skin.get("inv_slot", LabelStyle.java_class))
		@inv_window.add(@inv_item_desc4).align(Align::left).padLeft(5).colspan(8).height(12).row
		@inv_item_desc5 = Label.new('', @skin.get("inv_slot", LabelStyle.java_class))
		@inv_window.add(@inv_item_desc5).align(Align::left).padLeft(5).colspan(8).padBottom(4).height(12).row

		set_inventory_desc(@inv_desc)

		@inv_slots = []
		for i in 1..C::INVENTORY_SLOTS
			
			@inv_slots << ImageButton.new(@skin.get(ImageButtonStyle.java_class))
			@inv_slots.last.add_listener(

				Class.new(ClickListener) do
				
					def initialize(mgr, slot, atlas, ui)

						super()
						@ui = ui
						@mgr = mgr
						@slot = slot
						@atlas = atlas
					
					end

				
					def clicked(event, x, y)

						if @slot && @slot == @ui.inv_selection

							inv_comp = @mgr.get_component(@ui.player, Inventory)

							index = @ui.inv_slots.index(@slot)
							item = inv_comp.items[index]

							type_comp = @mgr.get_component(item, Type)
							
						else
						
							style = ImageButtonStyle.new(@ui.inv_selection.style)
							style.up = TextureRegionDrawable.new(@atlas.find_region('inv_slot'))
							@ui.inv_selection.style = style

							@ui.inv_selection = @slot

							style = ImageButtonStyle.new(@ui.inv_selection.style)
							style.up = TextureRegionDrawable.new(@atlas.find_region('inv_selection'))
							@ui.inv_selection.style = style

						end

					end

				end.new(@mgr, @inv_slots.last, @atlas, self))

			if i % 8 == 0
				@inv_window.add(@inv_slots.last).pad(1).row
			else
				@inv_window.add(@inv_slots.last).pad(1)
			end

		end

		@inv_selection = @inv_slots[0]
		style = ImageButtonStyle.new(@inv_selection.style)
		style.up = TextureRegionDrawable.new(@atlas.find_region('inv_selection'))
		@inv_selection.style = style

		@main_table.add(@inv_button).width(90).height(14).colspan(2)

	end


	def set_inventory_name(name)

		@inv_item_name.text = name

	end


	def set_inventory_desc(desc)

		@inv_desc_lines = desc.scan(/.{1,46}\b|.{1,46}/).map(&:strip)

		while @inv_desc_lines.size < 5
			@inv_desc_lines << ""
		end

		@inv_item_desc1.text = @inv_desc_lines[0]
		@inv_item_desc2.text = @inv_desc_lines[1]
		@inv_item_desc3.text = @inv_desc_lines[2]
		@inv_item_desc4.text = @inv_desc_lines[3]
		@inv_item_desc5.text = @inv_desc_lines[4]

	end


	def update(delta, batch)

		if @base_active

			needs_comp = @mgr.get_component(@player, Needs)
			inv_comp = @mgr.get_component(@player, Inventory)

			@base_time.text = @mgr.time.time
			@base_date.text = @mgr.time.date
			@base_money.text = "$%.2f" % [inv_comp.money]

			@base_hunger.width = (needs_comp.hunger * 100 + 4).to_i
			@base_thirst.width = (needs_comp.thirst * 100 + 4).to_i
			@base_energy.width = (needs_comp.energy * 100 + 4).to_i
			@base_sanity.width = (needs_comp.sanity * 100 + 4).to_i

			if @inv_selection != @prev_selection

				index = @inv_slots.index(@inv_selection)
				item = inv_comp.items[index]

				if item

					info_comp = @mgr.get_component(item, Info)

					@inv_item_name.text = info_comp.name
					set_inventory_desc(info_comp.description)

				else

					@inv_item_name.text = "Empty"
					set_inventory_desc("")

				end

			end

			@prev_selection = @inv_selection

		end

		if @base_update

			@base_update = false

			if @base_active
				@stage.add_actor(@base_table)
				@stage.add_actor(@base_table_needs)
			else
				@base_table.remove
				@base_table_needs.remove
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

		if @main_active || @base_active
			
			@stage.act

			@stage.draw

			Table.draw_debug(@stage)

		end

	end

end