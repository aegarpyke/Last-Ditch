class UISystem < System

  attr_accessor :active, :toggle, :focus, :focus_actor
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
   
    setup_buttons
    setup_initial_state

    if 1 == 0
      @window.debug
    end
  end

  def setup_initial_state
    @focus = :actions
    @focus_actor = @actions.table

    @window.add(@actions.table).width(680).height(432)

    @mgr.ui.actions.activate
    @window.get_cell(@focus_actor).set_actor(@actions.table)

    @actions_button.set_checked(true)
    @inventory_button.set_checked(false)
    @equipment_button.set_checked(false)
    @status_button.set_checked(false)

    @focus_actor = @actions.table
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
      @mgr.ui.actions.activate
      @window.get_cell(@focus_actor).set_actor(@actions.table)

      @actions_button.set_checked(true)
      @inventory_button.set_checked(false)
      @equipment_button.set_checked(false)
      @status_button.set_checked(false)

      @focus_actor = @actions.table
    elsif focus == :inventory
      @mgr.ui.inventory.activate 
      @window.get_cell(@focus_actor).set_actor(@inventory.table)

      @actions_button.set_checked(false)
      @inventory_button.set_checked(true)
      @equipment_button.set_checked(false)
      @status_button.set_checked(false)

      @focus_actor = @inventory.table
    elsif focus == :equipment
      @mgr.ui.equipment.activate
      @window.get_cell(@focus_actor).set_actor(@equipment.table) 
      
      @actions_button.set_checked(false)
      @inventory_button.set_checked(false)
      @equipment_button.set_checked(true)
      @status_button.set_checked(false)

      @focus_actor = @equipment.table
    elsif focus == :status
      @mgr.ui.status.activate
      @window.get_cell(@focus_actor).set_actor(@status.table)

      @actions_button.set_checked(false)
      @inventory_button.set_checked(false)
      @equipment_button.set_checked(false)
      @status_button.set_checked(true)
      
      @focus_actor = @status.table
    end
  end

  def update
    @base.update

    @actions.update
    @inventory.update
    @equipment.update
    @status.update
  end

  def activate(focus)
    @active = true
    
    @focus = focus
    switch_focus(@focus)

    @stage.add_actor(@window)
  end

  def deactivate
    @active = false

    @actions.deactivate
    @inventory.deactivate
    @equipment.deactivate
    @status.deactivate

    @window.remove
  end

  def toggle_active
    @active = !@active

    if @active
    else
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
