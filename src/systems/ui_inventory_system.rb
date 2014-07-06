class UIInventorySystem < System

  attr_accessor :active, :toggle, :window, :selection, :prev_selection, :slots, :no_exit

  def initialize(mgr, stage, skin)
    
    super()

    @mgr = mgr
    @skin = skin
    @stage = stage
    @active = true
    @no_exit = false
    @prev_selection = nil

    setup

    if 1 == 0

      @window.debug

    end

  end


  def setup

    @item_name        = Label.new("", @skin, "inv")
    @item_desc        = Label.new("", @skin, "inv")
    @item_value       = Label.new("", @skin, "inv")
    @item_weight      = Label.new("", @skin, "inv")
    @item_quality_dur = Label.new("", @skin, "inv")
    
    @item_value.color       = Color.new(0.75, 0.82, 0.70, 1.0)
    @item_weight.color      = Color.new(0.75, 0.75, 0.89, 1.0)
    @item_quality_dur.color = Color.new(0.8, 0.8, 0.8, 1.0)

    @item_desc.alignment = Align::top | Align::left
    @item_desc.wrap = true

    @window = Window.new("Inventory", @skin, "window1")
    @window.set_position(262, 2)
    @window.set_size(276, 236)
    @window.movable = false
    @window.padTop(9)
    @window.add_listener(
      
      Class.new(ClickListener) do

        def initialize(inv)
          super()
          @inv = inv
        end

        def exit(event, x, y, pointer, to_actor)
          @inv.exit_window
        end

      end.new(self))

    @window.add(@item_name).colspan(4).align(Align::left).padTop(4).height(12)
    @window.add(@item_value).colspan(4).align(Align::right).padTop(4).height(14).row
    @window.add(@item_weight).colspan(4).align(Align::left).height(14).padTop(1)
    @window.add(@item_quality_dur).colspan(4).align(Align::right).padTop(1).height(12).row
    @window.add(@item_desc).colspan(8).width(256).height(62).row

    @slots = []

    for i in 1..C::INVENTORY_SLOTS
      
      @slots << ImageButton.new(@skin, "inv_slot")
      
      @slots.last.add_listener(

        Class.new(ClickListener) do
        
          def initialize(inv, slot)
            super()
            @inv = inv
            @slot = slot
          end


          def enter(event, x, y, pointer, from_actor)
            @inv.enter_slot(@slot)
            true
          end


          def clicked(event, x, y)
            @inv.no_exit = true
            @inv.use_item
            true
          end

        end.new(self, @slots.last))

      if i % 8 == 0
        @window.add(@slots.last).pad(0).row
      else
        @window.add(@slots.last).pad(0)
      end

    end

  end


  def enter_slot(slot)

    if @selection
              
      style = ImageButtonStyle.new(@selection.style)
      style.up = TextureRegionDrawable.new(@mgr.atlas.find_region('inv_slot'))
      @selection.style = style

    end

    @selection = slot

    style = ImageButtonStyle.new(@selection.style)
    style.up = TextureRegionDrawable.new(@mgr.atlas.find_region('inv_selection'))
    @selection.style = style

  end


  def exit_window

    if @no_exit
      
      @no_exit = false
    
    else

      if @selection
          
        style = ImageButtonStyle.new(@selection.style)
        style.up = TextureRegionDrawable.new(@mgr.atlas.find_region('inv_slot'))
        @selection.style = style

        @selection = nil              

      end 

    end

  end


  def set_item_qual_cond(quality, condition)
    
    unless quality == -1 && condition == -1
      @item_quality_dur.text = "Q-%d C-%d" % [(quality * 100).to_i, (condition * 100).to_i]
    else
      @item_quality_dur.text = ""
    end
  end


  def set_item_value(value)

    unless value == -1
      @item_value.text = "$%.2f" % value
    else
      @item_value.text = ""
    end

  end


  def set_item_weight(weight)

    unless weight == -1
      @item_weight.text = " %.1fkg" % weight
    else
      @item_weight.text = ""
    end

  end


  def set_item_name(name)
    @item_name.text = name
  end


  def set_item_desc(desc)
    @item_desc.text = desc
  end


  def reset_info

    set_item_name("")
    set_item_qual_cond(-1, -1)
    set_item_value(-1)
    set_item_weight(-1)
    set_item_desc("")

  end


  def use_item

    @selection                               and
    index = @slots.index(@selection)         and
    inv = @mgr.comp(@mgr.player, Inventory)  and
    item_id = inv.items[index]               and
    item = @mgr.comp(item_id, Item)          and
    item.usable                              and

    Proc.new do
    
      type = @mgr.comp(item_id, Type)
      info = @mgr.comp(item_id, Info)

      @mgr.inventory.use_item(@mgr.player, item_id, type.type)

      set_item_name(info.name)
      set_item_desc(info.desc)
      set_item_qual_cond(item.quality, item.condition)
      set_item_value(item.value)
      set_item_weight(item.weight)

      true
    
    end.call

    false

  end

  def update

    update_view

    if @active

      if @selection != @prev_selection

        if @selection

          inv = @mgr.comp(@mgr.player, Inventory)
          index = @slots.index(@selection)

          if item_id = inv.items[index]

            item = @mgr.comp(item_id, Item)
            info = @mgr.comp(item_id, Info)

            set_item_name(info.name)
            set_item_qual_cond(item.quality, item.condition)
            set_item_value(item.value)
            set_item_weight(item.weight)
            set_item_desc(info.desc)

          else

            reset_info

          end

        else

          reset_info

        end

      end

      @prev_selection = @selection

    end

  end


  def update_view

    if @toggle

      @toggle = false
      @active = !@active

      if @active
        @stage.add_actor(@window)
      else
        @window.remove
      end

    end

  end

end