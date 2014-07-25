class UIEquipSystem < System

  attr_accessor :active, :toggle, :window

  def initialize(mgr, stage)
    
    super()

    @mgr = mgr
    @skin = @mgr.skin
    @stage = stage
    @active = false

    setup

    if 1 == 0

      @window.debug

    end

  end


  def setup

    @window = Window.new("Equipment", @skin, "window1")
    @window.set_position(0, 44)
    @window.set_size(250, 290)
    @window.set_movable(false)
    @window.padTop(9)
    @window.align(Align::center)
    
    @l_head_box = SelectBox.new(@skin, "equipment")
    @r_head_box = SelectBox.new(@skin, "equipment")
    @l_arm_box  = SelectBox.new(@skin, "equipment")
    @torso_box  = SelectBox.new(@skin, "equipment")
    @r_arm_box  = SelectBox.new(@skin, "equipment")
    @l_hand_box = SelectBox.new(@skin, "equipment")
    @belt_box   = SelectBox.new(@skin, "equipment")
    @r_hand_box = SelectBox.new(@skin, "equipment")
    @l_leg_box  = SelectBox.new(@skin, "equipment")
    @r_leg_box  = SelectBox.new(@skin, "equipment")
    @l_foot_box = SelectBox.new(@skin, "equipment")
    @r_foot_box = SelectBox.new(@skin, "equipment")

    @desc = Label.new(
      "This is a description of whatever it is that needs to be described. "\
      "The act of describing something worth a description is a worthwhile "\
      "act, and therefore this act also merits a description. This "\
      "description is that description.",
      @skin, "equip")
    @desc.set_wrap(true)

    equip_box_size = 120

    @window.add(@l_head_box).width(equip_box_size).padTop(8).padRight(0)
    @window.add(@r_head_box).width(equip_box_size).padTop(8).row
    @window.add(@l_arm_box).width(equip_box_size).padRight(0)
    @window.add(@r_arm_box).width(equip_box_size).row
    @window.add(@torso_box).width(equip_box_size).colspan(2).row
    @window.add(@l_hand_box).width(equip_box_size).padRight(0)
    @window.add(@r_hand_box).width(equip_box_size).row
    @window.add(@belt_box).width(equip_box_size).colspan(2).row
    @window.add(@l_leg_box).width(equip_box_size).padRight(0)
    @window.add(@r_leg_box).width(equip_box_size).row
    @window.add(@l_foot_box).width(equip_box_size).padRight(0)
    @window.add(@r_foot_box).width(equip_box_size).row

    @window.add(@desc).padTop(6).colspan(3).width(240)

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

      equipable = @mgr.comp(item_id, Equipable) and

      Proc.new do

        info = @mgr.comp(item_id, Info)

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

      end.call
      
    end

  end


  def update


  end


  def activate

    @active = true
    @mgr.ui.active = true
    @stage.add_actor(@window)

  end


  def deactivate

    @active = false
    @window.remove

  end


  def toggle_active
  
    @active = !@active

    if @active
      @stage.add_actor(@window)
    else
      @window.remove
    end
    
  end

end