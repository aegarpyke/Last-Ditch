class UIBaseSystem < System

  attr_accessor :active, :toggle, :selection, :no_exit, :slots, :window
  attr_accessor :time, :date, :money, :weight

  def initialize(mgr, stage, skin)

    super()

    @mgr = mgr
    @skin = skin
    @stage = stage
    @active = true
    @toggle = false
    @no_exit = false

    setup

    if 1 == 0
      
      @table_main.debug
      @table_needs.debug
      @table_slots.debug

    end

  end


  def setup

    w, h = 62, 42
    @table = Table.new(@skin)
    @table.set_bounds(C::WIDTH - w, C::HEIGHT - h, w, h)

    @time =   Label.new("", @skin, "base_ui")
    @date =   Label.new("", @skin, "base_ui")
    @money =  Label.new("", @skin, "base_ui")
    @weight = Label.new("", @skin, "base_ui")

    @money.set_alignment(Align::right)
    @money.set_color(Color.new(0.75, 0.82, 0.70, 1))
    @weight.set_alignment(Align::right)
    @weight.set_color(Color.new(0.75, 0.75, 0.89, 1))

    @table.add(@date).align(Align::right).height(11).row
    @table.add(@time).align(Align::right).height(11).row
    @table.add(@weight).align(Align::right).height(11).row
    @table.add(@money).align(Align::right).height(11)

    @table_needs = Table.new(@skin)
    @table_needs.set_bounds(-3, C::HEIGHT - 29, 106, 30)

    @hunger = ImageButton.new(@skin, "status_bars")
    @thirst = ImageButton.new(@skin, "status_bars")
    @energy = ImageButton.new(@skin, "status_bars")
    @sanity = ImageButton.new(@skin, "status_bars")
    
    @hunger.set_color(Color.new(0.94, 0.35, 0.34, 1))
    @thirst.set_color(Color.new(0.07, 0.86, 0.86, 1))
    @energy.set_color(Color.new(0.98, 0.98, 0.04, 1))
    @sanity.set_color(Color.new(0.77, 0.10, 0.87, 1))

    @table_needs.add(@hunger).width(106).padTop(0).height(7).row
    @table_needs.add(@thirst).width(106).padTop(0).height(7).row
    @table_needs.add(@energy).width(106).padTop(0).height(7).row
    @table_needs.add(@sanity).width(106).padTop(0).height(7)

    @selection = nil

    @table_slots = Table.new(@skin)
    @table_slots.set_bounds(0, 0, C::WIDTH, 32)
    @table_slots.add_listener(

      Class.new(ClickListener) do

        def initialize(base)
          super()
          @base = base
        end

        def exit(event, x, y, pointer, to_actor)
          @base.exit_window
          true
        end

      end.new(self))

    @slots = []

    for i in 1..C::BASE_SLOTS
      
      @slots << ImageButton.new(@skin, "base_slot")

      @slots.last.add_listener(

        Class.new(ClickListener) do
        
          def initialize(base, slot)
            super()
            @base = base
            @slot = slot
          end

          def enter(event, x, y, pointer, from_actor)
            @base.enter_slot(@slot)
            true
          end

          def clicked(event, x, y)
            @base.no_exit = true
            true
          end

        end.new(self, @slots.last))

      if i < 9
        @table_slots.add(@slots.last).align(Align::left)
      elsif i == 9
        @table_slots.add(@slots.last).align(Align::right).padLeft(286)
      else
        @table_slots.add(@slots.last).align(Align::right)
      end

    end

    @stage.add_actor(@table)
    @stage.add_actor(@table_needs)
    @stage.add_actor(@table_slots)

  end


  def exit_window

    if @no_exit
          
      @no_exit = false

    else
    
      if @selection
          
        style = ImageButtonStyle.new(@selection.style)
        style.up = TextureRegionDrawable.new(@mgr.atlas.find_region('base_slot'))
        @selection.style = style

        @selection = nil

      end 
    
    end

  end


  def enter_slot(slot)

    if @selection

      style = ImageButtonStyle.new(@selection.style)
      style.up = TextureRegionDrawable.new(@mgr.atlas.find_region('base_slot'))
      @selection.style = style

    end

    @selection = slot

    style = ImageButtonStyle.new(@selection.style)
    style.up = TextureRegionDrawable.new(@mgr.atlas.find_region('base_selection'))
    @selection.style = style

  end


  def update

    update_view

    if @active

      needs = @mgr.comp(@mgr.player, Needs)
      inv = @mgr.comp(@mgr.player, Inventory)

      @time.text   = @mgr.time.time
      @date.text   = @mgr.time.date
      @money.text  = "$%.2f" % inv.money
      @weight.text = "%.1fkg" % inv.weight

      @hunger.width = (needs.hunger * 100 + 4).to_i
      @thirst.width = (needs.thirst * 100 + 4).to_i
      @energy.width = (needs.energy * 100 + 4).to_i
      @sanity.width = (needs.sanity * 100 + 4).to_i

    end

  end


  def update_view

    if @toggle

      @toggle = false
      @active = !@active

      if @active

        @stage.add_actor(@table)
        @stage.add_actor(@table_needs)
        @stage.add_actor(@table_slots)
      
      else
      
        @table.remove
        @table_needs.remove
        @table_slots.remove
      
      end
    
    end

  end

end

