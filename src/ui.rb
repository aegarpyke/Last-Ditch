class UI

	attr_accessor :stage, :inv_slots, :player
	attr_accessor :actions, :inventory, :equipment, :status, :inv_selection
	attr_accessor :base_active, :main_active, :inv_active, :actions_active, :equip_active, :status_active
	attr_accessor :base_update, :main_update, :inv_update, :actions_update, :equip_update, :status_update

	def initialize(mgr, player)

		debug = 0
		@tmp_counter = 0

		@base_active = true
 		@main_active = false
 		@main_update = true
 		@base_update = true
		@mgr = mgr
		@player = player
		@mgr.ui = self
		@atlas = mgr.atlas
		@stage = Stage.new
		@skin = Skin.new(Gdx.files.internal('cfg/uiskin.json'), @atlas)

		###########
		# Base UI #
		###########

		@base_table = Table.new(@skin)
		@base_table.set_bounds(-2, Gdx.graphics.height - 38, Gdx.graphics.width, 38)

		@base_time = Label.new("", @skin.get("base_ui", LabelStyle.java_class))
		@base_date = Label.new("", @skin.get("base_ui", LabelStyle.java_class))
		@base_money = Label.new("", @skin.get("base_ui", LabelStyle.java_class))
		@base_money.color = Color.new(0.75, 0.9, 0.70, 1.0)

		@base_table.add(@base_date).align(Align::left).padRight(730).height(12).row
		@base_table.add(@base_time).align(Align::left).padRight(730).height(12).row
		@base_table.add(@base_money).align(Align::left).padRight(730).height(12)

		###########
		# Main UI #
		###########

		@main_table = Table.new(@skin)
		@main_table.set_bounds(0, 0, Gdx.graphics.width, Gdx.graphics.height)

		@actions_active = false
		@actions_button = TextButton.new("Actions", @skin.get(TextButtonStyle.java_class))
		@actions_button.add_listener(
			Class.new(ClickListener) do
				def initialize(mgr)
					super()
					@mgr = mgr
				end

				def clicked(event, x, y)
					@mgr.ui.actions_update = true
					@mgr.ui.actions_active = !@mgr.ui.actions_active
				end
			end.new(@mgr))

		@actions_window = Window.new("Actions", @skin.get(WindowStyle.java_class))
		@actions_window.set_position(340, 400)
		@actions_window.padTop(9)

		@equip_active = false
		@equip_button = TextButton.new("Equipment", @skin.get(TextButtonStyle.java_class))
		@equip_button.add_listener(
			Class.new(ClickListener) do
				def initialize(mgr)
					super()
					@mgr = mgr
				end

				def clicked(event, x, y)
					@mgr.ui.equip_update = true
					@mgr.ui.equip_active = !@mgr.ui.equip_active
				end
			end.new(@mgr))

		@equip_window = Window.new("Equipment", @skin.get(WindowStyle.java_class))
		@equip_window.set_position(12, 260)
		@equip_window.padTop(9)

		@inv_active = false
		@inv_button = TextButton.new("Inventory", @skin.get(TextButtonStyle.java_class))
		@inv_listener = @inv_button.add_listener(
			Class.new(ClickListener) do
				def initialize(mgr)
					super()
					@mgr = mgr
				end

				def clicked(event, x, y)
					@mgr.ui.inv_update = true
					@mgr.ui.inv_active = !@mgr.ui.inv_active
				end
			end.new(@mgr))

		@inv_window = Window.new("Inventory", @skin.get(WindowStyle.java_class))
		@inv_window.set_position(280, 4)
		@inv_window.set_size(288, 236)
		@inv_window.padTop(9)

		@inv_item_name = Label.new("Rations", @skin.get("inv_slot", LabelStyle.java_class))
		@inv_window.add(@inv_item_name).colspan(8).align(Align::left).padLeft(2).padTop(8).padBottom(2).height(12).row

		@inv_desc = "This is a rather long string. It's just way too long "\
								"- longer than any reasonable string ever should be. I"\
								" mean, it just doesn't stop. Running around extending "\
								"words and stuff."

		@inv_desc_lines = @inv_desc.scan(/.{1,46}\b|.{1,46}/).map(&:strip)
		@inv_desc_lines[-2] += "."
		@inv_desc_lines[-1] = ""

		while @inv_desc_lines.size < 5
			@inv_desc_lines << ""
		end

		@inv_item_desc1 = Label.new(@inv_desc_lines[0], @skin.get("inv_slot", LabelStyle.java_class))
		@inv_window.add(@inv_item_desc1).align(Align::left).padLeft(8).colspan(8).height(12).row
		@inv_item_desc2 = Label.new(@inv_desc_lines[1], @skin.get("inv_slot", LabelStyle.java_class))
		@inv_window.add(@inv_item_desc2).align(Align::left).padLeft(5).colspan(8).height(12).row
		@inv_item_desc3 = Label.new(@inv_desc_lines[2], @skin.get("inv_slot", LabelStyle.java_class))
		@inv_window.add(@inv_item_desc3).align(Align::left).padLeft(5).colspan(8).height(12).row
		@inv_item_desc4 = Label.new(@inv_desc_lines[3], @skin.get("inv_slot", LabelStyle.java_class))
		@inv_window.add(@inv_item_desc4).align(Align::left).padLeft(5).colspan(8).height(12).row
		@inv_item_desc5 = Label.new(@inv_desc_lines[4], @skin.get("inv_slot", LabelStyle.java_class))
		@inv_window.add(@inv_item_desc5).align(Align::left).padLeft(5).colspan(8).padBottom(4).height(12).row

		@inv_slots = []
		for i in 1..C::INVENTORY_SLOTS
			
			@inv_slots << ImageButton.new(@skin.get(ImageButtonStyle.java_class))
			@inv_slots[-1].add_listener(
				Class.new(ClickListener) do
					def initialize(mgr, slot)
						super()
						@slot = slot
						@mgr = mgr
					end

					def clicked(event, x, y)

						if @slot == @mgr.ui.inv_selection

							# Use item in slot

							inv_comp = @mgr.get_component(@mgr.ui.player, Inventory)

							index = @mgr.ui.inv_slots.index(@slot)
							item = inv_comp.items[index]

							type_comp = @mgr.get_component(item, Type)
							
							if type_comp
								puts type_comp.type
							else
								puts "empty"
							end

						else
						
							style = ImageButtonStyle.new(@mgr.ui.inv_selection.style)
							style.up = TextureRegionDrawable.new(@mgr.atlas.find_region('inv_slot'))
							@mgr.ui.inv_selection.style = style

							@mgr.ui.inv_selection = @slot

							style = ImageButtonStyle.new(@mgr.ui.inv_selection.style)
							style.up = TextureRegionDrawable.new(@mgr.atlas.find_region('inv_selection'))
							@mgr.ui.inv_selection.style = style

						end

					end
				end.new(@mgr, @inv_slots.last))

			if i % 8 == 0
				@inv_window.add(@inv_slots.last).pad(1).row
			else
				@inv_window.add(@inv_slots.last).pad(1)
			end

		end

		@inv_selection = @inv_slots[0]
		style = ImageButtonStyle.new(@inv_selection.style)
		style.up = TextureRegionDrawable.new(@mgr.atlas.find_region('inv_selection'))
		@inv_selection.style = style

		@status_active = false
		@status_button = TextButton.new("Status", @skin.get(TextButtonStyle.java_class))
		@status_button.add_listener(
			Class.new(ClickListener) do
				def initialize(mgr)
					super()
					@mgr = mgr
				end

				def clicked(event, x, y)
					@mgr.ui.status_update = true
					@mgr.ui.status_active = !@mgr.ui.status_active
				end
			end.new(@mgr))

		@status_window = Window.new("Status", @skin.get(WindowStyle.java_class))
		@status_window.set_position(500, 260)
		@status_window.padTop(9)

		@main_table.add(@actions_button).width(90).height(14).colspan(2).row
		@main_table.add(@equip_button).width(90).height(14).padTop(24).padBottom(24).padRight(60)
		@main_table.add(@status_button).width(90).height(14).padTop(24).padBottom(24).row
		@main_table.add(@inv_button).width(90).height(14).colspan(2)

		if debug != 0
			@main_table.debug
			@base_table.debug
			@inv_window.debug
			@actions_window.debug
			@status_window.debug
			@equip_window.debug
		end

		##############
		# UI Systems #
		##############
		@actions = ActionsSystem.new(@mgr)
		@inventory = InventorySystem.new(@mgr)
		@equipment = EquipmentSystem.new(@mgr)
		@status = StatusSystem.new(@mgr)

	end


	def update(delta)

		if @base_active

			@base_time.text = @mgr.game_time.time
			@base_date.text = @mgr.game_time.date
			@base_money.text = "$%.2f" % [@mgr.get_component(@player, Inventory).money]

		end

		if @base_update
			@base_update = false

			if @base_active
				@stage.add_actor(@base_table)
			else
				@base_table.remove
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
		end

		@actions.tick(delta) if @actions_active
		@inventory.tick(delta) if @inv_active
		@equipment.tick(delta) if @equipment_active
		@status.tick(delta) if @status_active

	end


	def render(batch)

		if @main_active || @base_active

			@stage.draw

			Table.draw_debug(@stage)

		end

	end

end