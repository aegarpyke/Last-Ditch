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
    @window.add(@desc).padTop(18).colspan(3).width(240)

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