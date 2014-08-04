class UIEquipSystem < System

  attr_accessor :active, :toggle, :window, :table

  def initialize(mgr, window)
    
    super()

    @mgr = mgr
    @window = window
    @active = false
    @skin = @mgr.skin

    setup

    if 1 == 0

      @table.debug

    end

  end


  def setup

    @table = Table.new
    @table.set_position(0, 44)
    @table.set_size(250, 290)
    
    @l_head_box = SelectBox.new(@skin, "equipment")
    @l_head_box.add_listener(

      Class.new(ChangeListener) do

        def initialize(equip)
          super()
          @equip = equip
        end

        def changed(event, actor)
          @equip.set_equipment('l_head', actor.get_selection)
          true
        end

      end.new(self))

    @r_head_box = SelectBox.new(@skin, "equipment")
    @r_head_box.add_listener(

      Class.new(ChangeListener) do

        def initialize(equip)
          super()
          @equip = equip
        end

        def changed(event, actor)
          @equip.set_equipment('r_head', actor.get_selection)
          true
        end

      end.new(self))

    @l_arm_box  = SelectBox.new(@skin, "equipment")
    @l_arm_box.add_listener(

      Class.new(ChangeListener) do

        def initialize(equip)
          super()
          @equip = equip
        end

        def changed(event, actor)
          @equip.set_equipment('l_arm', actor.get_selection)
          true
        end

      end.new(self))

    @torso_box  = SelectBox.new(@skin, "equipment")
    @torso_box.add_listener(

      Class.new(ChangeListener) do

        def initialize(equip)
          super()
          @equip = equip
        end

        def changed(event, actor)
          @equip.set_equipment('torso', actor.get_selection)
          true
        end

      end.new(self))
 
    @r_arm_box  = SelectBox.new(@skin, "equipment")
    @r_arm_box.add_listener(

      Class.new(ChangeListener) do

        def initialize(equip)
          super()
          @equip = equip
        end

        def changed(event, actor)
          @equip.set_equipment('r_arm', actor.get_selection)
          true
        end

      end.new(self))

    @l_hand_box = SelectBox.new(@skin, "equipment")
    @l_hand_box.add_listener(

      Class.new(ChangeListener) do

        def initialize(equip)
          super()
          @equip = equip
        end

        def changed(event, actor)
          @equip.set_equipment('l_hand', actor.get_selection)
          true
        end

      end.new(self))

    @belt_box = SelectBox.new(@skin, "equipment")
    @belt_box.add_listener(

      Class.new(ChangeListener) do

        def initialize(equip)
          super()
          @equip = equip
        end

        def changed(event, actor)
          @equip.set_equipment('belt', actor.get_selection)
          true
        end

      end.new(self))

    @r_hand_box = SelectBox.new(@skin, "equipment")
    @r_hand_box.add_listener(

      Class.new(ChangeListener) do

        def initialize(equip)
          super()
          @equip = equip
        end

        def changed(event, actor)
          @equip.set_equipment('r_hand', actor.get_selection)
          true
        end

      end.new(self))

    @l_leg_box  = SelectBox.new(@skin, "equipment")
    @l_leg_box.add_listener(

      Class.new(ChangeListener) do

        def initialize(equip)
          super()
          @equip = equip
        end

        def changed(event, actor)
          @equip.set_equipment('l_leg', actor.get_selection)
          true
        end

      end.new(self))

    @r_leg_box  = SelectBox.new(@skin, "equipment")
    @r_leg_box.add_listener(

      Class.new(ChangeListener) do

        def initialize(equip)
          super()
          @equip = equip
        end

        def changed(event, actor)
          @equip.set_equipment('r_leg', actor.get_selection)
          true
        end

      end.new(self))

    @l_foot_box = SelectBox.new(@skin, "equipment")
    @l_foot_box.add_listener(

      Class.new(ChangeListener) do

        def initialize(equip)
          super()
          @equip = equip
        end

        def changed(event, actor)
          @equip.set_equipment('l_foot', actor.get_selection)
          true
        end

      end.new(self))

    @r_foot_box = SelectBox.new(@skin, "equipment")
    @r_foot_box.add_listener(

      Class.new(ChangeListener) do

        def initialize(equip)
          super()
          @equip = equip
        end

        def changed(event, actor)
          @equip.set_equipment('r_foot', actor.get_selection)
          true
        end

      end.new(self))

    @desc = Label.new(
      "This is a description of whatever it is that needs to be described. "\
      "The act of describing something worth a description is a worthwhile "\
      "act, and therefore this act also merits a description. This "\
      "description is that description.",
      @skin, "equipment")
    @desc.set_wrap(true)

    equip_box_size = 120

    @table.add(@l_head_box).width(equip_box_size).padTop(8).padRight(0)
    @table.add(@r_head_box).width(equip_box_size).padTop(8).row
    @table.add(@l_arm_box).width(equip_box_size).padRight(0)
    @table.add(@r_arm_box).width(equip_box_size).row
    @table.add(@torso_box).width(equip_box_size).colspan(2).row
    @table.add(@l_hand_box).width(equip_box_size).padRight(0)
    @table.add(@r_hand_box).width(equip_box_size).row
    @table.add(@belt_box).width(equip_box_size).colspan(2).row
    @table.add(@l_leg_box).width(equip_box_size).padRight(0)
    @table.add(@r_leg_box).width(equip_box_size).row
    @table.add(@l_foot_box).width(equip_box_size).padRight(0)
    @table.add(@r_foot_box).width(equip_box_size).row

    @table.add(@desc).padTop(6).colspan(3).width(240)

  end


  def setup_slots

    inv = @mgr.comp(@mgr.player, Inventory)

    @head_list  = GdxArray.new
    @arm_list   = GdxArray.new
    @torso_list = GdxArray.new
    @hand_list  = GdxArray.new
    @belt_list  = GdxArray.new
    @leg_list   = GdxArray.new
    @foot_list  = GdxArray.new

    @head_list.add('none')
    @arm_list.add('none')
    @torso_list.add('none')
    @hand_list.add('none')
    @belt_list.add('none')
    @leg_list.add('none')
    @foot_list.add('none')
    
    for item_id in inv.items

      if equipable = @mgr.comp(item_id, Equipable)

        info = @mgr.comp(item_id, Info)

        equip = @mgr.comp(@mgr.player, Equipment)

        @mgr.equipment.equip(equip, item_id)

        if equipable.types.include?('l_head') ||
           equipable.types.include?('r_head')

          @head_list.add(info.name)

        elsif equipable.types.include?('l_arm') ||
              equipable.types.include?('r_arm')

          @arm_list.add(info.name)

        elsif equipable.types.include?('torso')

          @torso_list.add(info.name)

        elsif equipable.types.include?('l_hand') ||
              equipable.types.include?('r_hand')

          @hand_list.add(info.name)

        elsif equipable.types.include?('belt')

          @belt_list.add(info.name)

        elsif equipable.types.include?('l_leg') ||
              equipable.types.include?('r_leg')

          @leg_list.add(info.name)

        elsif equipable.types.include?('l_foot') ||
              equipable.types.include?('r_foot')

          @foot_list.add(info.name)

        end

        @l_head_box.set_items(@head_list)
        @r_head_box.set_items(@head_list)
        @l_arm_box.set_items(@arm_list)
        @torso_box.set_items(@torso_list)
        @r_arm_box.set_items(@arm_list)
        @l_hand_box.set_items(@hand_list)
        @belt_box.set_items(@belt_list)
        @r_hand_box.set_items(@hand_list)
        @l_leg_box.set_items(@leg_list)
        @r_leg_box.set_items(@leg_list)
        @l_foot_box.set_items(@foot_list)
        @r_foot_box.set_items(@foot_list)

      end
      
    end

  end


  def set_equipment(type, slot_name)

    puts type, slot_name

  end


  def update


  end


  def activate

    @active = true

  end


  def deactivate

    @active = false

  end


  def toggle_active
  
    @active = !@active

    if @active
    else
    end
    
  end

end
