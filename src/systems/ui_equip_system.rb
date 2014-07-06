class UIEquipSystem < System

  attr_accessor :active, :toggle, :window

  def initialize(mgr, stage, skin)
    
    super()

    @mgr = mgr
    @stage = stage
    @skin = skin
    @active = true

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
    
    @l_head_label = Label.new("Endex", @skin, "equip")
    @r_head_label = Label.new("Ear piece", @skin, "equip")
    @l_arm_label  = Label.new("Empty", @skin, "equip")
    @torso_label  = Label.new("Flak jacket", @skin, "equip")
    @r_arm_label  = Label.new("GPS Device", @skin, "equip")
    @l_hand_label = Label.new("Empty", @skin, "equip")
    @belt_label   = Label.new("Engineer's belt", @skin, "equip")
    @r_hand_label = Label.new("Handgun", @skin, "equip")
    @l_leg_label  = Label.new("Kneepads", @skin, "equip")
    @r_leg_label  = Label.new("Kneepads", @skin, "equip")
    @l_foot_label = Label.new("Athletic shoes", @skin, "equip")
    @r_foot_label = Label.new("Athletic shoes", @skin, "equip")

    @l_head_label.set_alignment(Align::center)
    @r_head_label.set_alignment(Align::center)
    @l_arm_label .set_alignment(Align::center)
    @torso_label .set_alignment(Align::center)
    @r_arm_label .set_alignment(Align::center)
    @l_hand_label.set_alignment(Align::center)
    @belt_label  .set_alignment(Align::center)
    @r_hand_label.set_alignment(Align::center)
    @l_leg_label .set_alignment(Align::center)
    @r_leg_label .set_alignment(Align::center)
    @l_foot_label.set_alignment(Align::center)
    @r_foot_label.set_alignment(Align::center)

    @desc = Label.new(
      "This is a description of whatever it is that needs to be described. "\
      "The act of describing something worth a description is a worthwhile "\
      "act, and therefore this act also merits a description. This "\
      "description is that description.",
      @skin, "equip")
    @desc.set_wrap(true)

    equip_label_size = 120

    @window.add(@l_head_label).width(equip_label_size).padTop(8).padRight(0)
    @window.add(@r_head_label).width(equip_label_size).padTop(8).row
    @window.add(@l_arm_label).width(equip_label_size).padRight(0)
    @window.add(@r_arm_label).width(equip_label_size).row
    @window.add(@torso_label).width(equip_label_size).colspan(2).row
    @window.add(@l_hand_label).width(equip_label_size).padRight(0)
    @window.add(@r_hand_label).width(equip_label_size).row
    @window.add(@belt_label).width(equip_label_size).colspan(2).row
    @window.add(@l_leg_label).width(equip_label_size).padRight(0)
    @window.add(@r_leg_label).width(equip_label_size).row
    @window.add(@l_foot_label).width(equip_label_size).padRight(0)
    @window.add(@r_foot_label).width(equip_label_size).row
    @window.add(@desc).padTop(18).colspan(3).width(240)

  end


  def update

    update_view

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