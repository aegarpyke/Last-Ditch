class UISystem < System

	attr_accessor :active, :toggle
	attr_accessor :player, :stage, :atlas
	attr_accessor :base, :actions, :inventory, :equipment, :status
 
	def initialize(mgr, atlas)

		super()
		@mgr = mgr
		@skin = @mgr.skin
		@atlas = atlas
		@mgr.ui = self
		@active = false
		@toggle = false

		@stage = Stage.new

		@window = Window.new('', @skin, 'window1')
    @window.set_position(24, 54)
    @window.set_size(750, 490)
    @window.set_movable(false)
    @window.padTop(9)

		@base      = UIBaseSystem.new(@mgr, @stage)
		
		@actions   = UIActionsSystem.new(@mgr, @window)
		@inventory = UIInventorySystem.new(@mgr, @window)
		@equipment = UIEquipSystem.new(@mgr, @window)
		@status    = UIStatusSystem.new(@mgr, @window)

		@focus = @actions.table

		setup_buttons
		
		@window.add(@actions.table).width(680).height(432)
		
		switch_focus(:actions)

		if 1 == 1
			@window.debug
		end

	end


	def setup_buttons

		@actions_button = TextButton.new(
			"Actions", @skin, "actions_button")
		@inventory_button = TextButton.new(
			"Inventory", @skin, "actions_button")
		@equipment_button = TextButton.new(
			"Equipment", @skin, "actions_button")
		@status_button = TextButton.new(
			"Status", @skin, "actions_button")

    @actions_button.add_listener(

      Class.new(ClickListener) do

        def initialize(ui)
          super()
          @ui = ui
        end

        def clicked(event, x, y)
          @ui.switch_focus(:actions)
          true
        end

      end.new(self))

		@inventory_button.add_listener(

      Class.new(ClickListener) do

        def initialize(ui)
          super()
          @ui = ui
        end

        def clicked(event, x, y)
          @ui.switch_focus(:inventory)
          true
        end

      end.new(self))

		@equipment_button.add_listener(

      Class.new(ClickListener) do

        def initialize(ui)
          super()
          @ui = ui
        end

        def clicked(event, x, y)
          @ui.switch_focus(:equipment)
          true
        end

      end.new(self))

		@status_button.add_listener(

      Class.new(ClickListener) do

        def initialize(ui)
          super()
          @ui = ui
        end

        def clicked(event, x, y)
          @ui.switch_focus(:status)
          true
        end

      end.new(self))

		@button_table = Table.new
		@button_table.add(@actions_button).width(100).height(16).padRight(60)
		@button_table.add(@inventory_button).width(100).height(16).padRight(60)
		@button_table.add(@equipment_button).width(100).height(16).padRight(60)
		@button_table.add(@status_button).width(100).height(16).padRight(60)

		@window.add(@button_table).width(700).row
		
	end


	def switch_focus(focus)

    if focus == :actions

    	@window.get_cell(@focus).set_actor(@actions.table)
    	
    	@focus = @actions.table
			
      @actions_button.set_checked(true)
      @inventory_button.set_checked(false)
      @equipment_button.set_checked(false)
      @status_button.set_checked(false)

    elsif focus == :inventory

			@window.get_cell(@focus).set_actor(@inventory.table)
    	
    	@focus = @inventory.table

      @actions_button.set_checked(false)
      @inventory_button.set_checked(true)
      @equipment_button.set_checked(false)
      @status_button.set_checked(false)

    elsif focus == :equipment

    	@window.get_cell(@focus).set_actor(@equipment.table)
    	
    	@focus = @equipment.table

    	@actions_button.set_checked(false)
      @inventory_button.set_checked(false)
      @equipment_button.set_checked(true)
      @status_button.set_checked(false)

    elsif focus == :status

    	@window.get_cell(@focus).set_actor(@status.table)
    	
    	@focus = @status.table

    	@actions_button.set_checked(false)
      @inventory_button.set_checked(false)
      @equipment_button.set_checked(false)
      @status_button.set_checked(true)

    end

  end


	def update

		@base.update

		@actions.update
		@inventory.update
		@equipment.update
		@status.update
		
	end


	def activate

		@active = true
		@mgr.paused = true
		@mgr.time.active = false

		@actions.activate
		@inventory.activate
		@equipment.activate
		@status.activate

		@stage.add_actor(@window)

	end


	def deactivate

		@active = false
		@mgr.paused = false
    @mgr.time.active = true

		@actions.deactivate
		@inventory.deactivate
		@equipment.deactivate
		@status.deactivate

		@window.remove

	end


	def toggle_active

		@active = !@active

		if @active

			@actions.activate
			@inventory.activate
			@equipment.activate
			@status.activate
		
		else

			@mgr.paused = false
			@actions.deactivate
			@inventory.deactivate
			@equipment.deactivate
			@status.deactivate

		end

	end


	def render

		@stage.act
		@stage.draw

		Table.draw_debug(@stage)

	end

	def dispose


	end

end