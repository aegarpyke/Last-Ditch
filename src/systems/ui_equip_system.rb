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
          @equip.set_equipment('l_head', actor.get_selected_index)
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
          @equip.set_equipment('r_head', actor.get_selected_index)
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
          @equip.set_equipment('l_arm', actor.get_selected_index)
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
          @equip.set_equipment('torso', actor.get_selected_index)
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
          @equip.set_equipment('r_arm', actor.get_selected_index)
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
          @equip.set_equipment('l_hand', actor.get_selected_index)
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
          @equip.set_equipment('belt', actor.get_selected_index)
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
          @equip.set_equipment('r_hand', actor.get_selected_index)
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
          @equip.set_equipment('l_leg', actor.get_selected_index)
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
          @equip.set_equipment('r_leg', actor.get_selected_index)
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
          @equip.set_equipment('l_foot', actor.get_selected_index)
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
          @equip.set_equipment('r_foot', actor.get_selected_index)
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

  def setup_equipment_lists
    @head_items  = []
    @arm_items   = []
    @torso_items = []
    @hand_items  = []
    @belt_items  = []
    @leg_items   = []
    @foot_items  = []
 
    head_list  = GdxArray.new
    arm_list   = GdxArray.new
    torso_list = GdxArray.new
    hand_list  = GdxArray.new
    belt_list  = GdxArray.new
    leg_list   = GdxArray.new
    foot_list  = GdxArray.new
    
    head_list.add('none')
    arm_list.add('none')
    torso_list.add('none')
    hand_list.add('none')
    belt_list.add('none')
    leg_list.add('none')
    foot_list.add('none')
    
    inv = @mgr.comp(@mgr.player, Inventory)

    for item_id in inv.items
      if equippable = @mgr.comp(item_id, Equippable)
        types = equippable.types
        info = @mgr.comp(item_id, Info)

        if !(types & ['l_head', 'r_head']).empty?
          @head_items << item_id
          head_list.add(info.name)
        elsif !(types & ['l_arm', 'r_arm']).empty?
          @arm_items << item_id
          arm_list.add(info.name)
        elsif !(types & ['torso']).empty?
          @torso_items << item_id
          torso_list.add(info.name)
        elsif !(types & ['l_hand', 'r_hand']).empty?
          @hand_items << item_id
          hand_list.add(info.name)
        elsif !(types & ['belt']).empty?
          @belt_items << item_id
          belt_list.add(info.name)
        elsif !(types & ['l_leg', 'r_leg']).empty?
          @leg_items << item_id
          leg_list.add(info.name)
        elsif !(types & ['l_foot', 'r_foot']).empty?
          @foot_items << item_id
          foot_list.add(info.name)
        end
      end
    end
    
    @l_head_box.set_items(head_list)
    @r_head_box.set_items(head_list)
    @l_arm_box.set_items(arm_list)
    @torso_box.set_items(torso_list)
    @r_arm_box.set_items(arm_list)
    @l_hand_box.set_items(hand_list)
    @belt_box.set_items(belt_list)
    @r_hand_box.set_items(hand_list)
    @l_leg_box.set_items(leg_list)
    @r_leg_box.set_items(leg_list)
    @l_foot_box.set_items(foot_list)
    @r_foot_box.set_items(foot_list)
  end

  def set_equipment(slot, index)
    if index == 0
      @mgr.equipment.dequip(@mgr.player, slot)
      return
    end

    case slot
      when 'r_head', 'l_head'
        @mgr.equipment.equip(@mgr.player, slot, @head_items[index - 1])
      when 'r_hand', 'l_hand'
        @mgr.equipment.equip(@mgr.player, slot, @hand_items[index - 1])
      when 'l_arm', 'r_arm'
        @mgr.equipment.equip(@mgr.player, slot, @arm_items[index - 1])
      when 'torso'
        @mgr.equipment.equip(@mgr.player, slot, @torso_items[index - 1])
      when 'belt'
        @mgr.equipment.equip(@mgr.player, slot, @belt_items[index - 1])
      when 'r_leg', 'l_leg'
        @mgr.equipment.equip(@mgr.player, slot, @leg_items[index - 1])
      when 'r_foot', 'l_foot'
        @mgr.equipment.equip(@mgr.player, slot, @foot_items[index - 1])
    end
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
