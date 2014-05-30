class UI

	attr_accessor :stage
	attr_accessor :active, :inv_active, :actions_active, :equip_active, :status_active
	attr_accessor :update, :inv_update, :actions_update, :equip_update, :status_update

	def initialize(mgr, player)

		debug = true
		@tmp_counter = 0

 		@active = false
 		@update = true
		@mgr = mgr
		@player = player
		@mgr.ui = self
		@atlas = mgr.atlas
		@stage = Stage.new
		@skin = Skin.new(Gdx.files.internal('cfg/uiskin.json'), @atlas)

		# UI Systems
		@actions = ActionsSystem.new(@mgr)
		@inventory = InventorySystem.new(@mgr)
		@equipment = EquipmentSystem.new(@mgr)
		@status = StatusSystem.new(@mgr)

		@table = Table.new(@skin)
		@table.set_bounds(0, 0, Gdx.graphics.width, Gdx.graphics.height)

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
		@inv_window.set_size(288, 230)
		@inv_window.padTop(9)

		@inv_item_name = Label.new("Name", @skin.get("inv_slot", LabelStyle.java_class))
		@inv_window.add(@inv_item_name).colspan(8).align(Align::left).row

		@inv_item_desc = Label.new("Description: ", @skin.get("inv_slot", LabelStyle.java_class))
		@inv_window.add(@inv_item_desc).colspan(8).align(Align::left).row

		@inv_slots = []
		for i in 1...C::INVENTORY_SLOTS+1
			
			@inv_slots << ImageButton.new(@skin.get(ImageButtonStyle.java_class))
			if i % 8 == 0
				@inv_window.add(@inv_slots.last).pad(1).row
			else
				@inv_window.add(@inv_slots.last).pad(1)
			end
		
		end

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
		@status_window.set_position(400, 260)
		@status_window.padTop(9)

		@table.add(@actions_button).width(90).height(14).colspan(2).row
		@table.add(@equip_button).width(90).height(14).padTop(24).padBottom(24).padRight(60)
		@table.add(@status_button).width(90).height(14).padTop(24).padBottom(24).row
		@table.add(@inv_button).width(90).height(14).colspan(2)

		if debug
			@table.debug
			@inv_window.debug
			@actions_window.debug
			@status_window.debug
			@equip_window.debug
		end

	end


	def update(delta)

		if @update
			@update = false

			if @active
				@stage.add_actor(@table)
			else
				@table.remove
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

		if @active
			@stage.act
		end

		@actions.tick(delta) if @actions_active
		@inventory.tick(delta) if @inv_active
		@equipment.tick(delta) if @equipment_active
		@status.tick(delta) if @status_active

	end


	def render(batch)

		if @active

			@stage.draw

			Table.draw_debug(@stage)

		else

		end

	end

end