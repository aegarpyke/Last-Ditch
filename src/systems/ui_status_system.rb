class UIStatusSystem < System

  attr_accessor :active, :toggle, :window

  def initialize(mgr, stage, skin)
    
    super()

    @mgr = mgr
    @active = true
    @stage = stage
    @skin = skin

    setup

    if 1 == 0

      @window.debug
      @table_model.debug

    end

  end


  def setup

    @window = Window.new("Status", @skin, "window1")
    @window.set_position(560, 44)
    @window.set_size(250, 290)
    @window.movable = false
    @window.padTop(9)

    @table_model = Table.new(@skin)

    info = @mgr.comp(@mgr.player, Info)

    r_head_tex = TextureRegion.new(@mgr.atlas.find_region('status_head'))
    r_arm_tex  = TextureRegion.new(@mgr.atlas.find_region('status_arm'))
    r_hand_tex = TextureRegion.new(@mgr.atlas.find_region('status_hand'))
    r_leg_tex  = TextureRegion.new(@mgr.atlas.find_region('status_leg'))
    r_foot_tex = TextureRegion.new(@mgr.atlas.find_region('status_foot'))

    r_head_tex.flip(true, false)
    r_arm_tex.flip(true, false)
    r_hand_tex.flip(true, false)
    r_leg_tex.flip(true, false)
    r_foot_tex.flip(true, false)

    @name = Label.new(
      "Name: %s" % info.name, @skin, "status")
    @occupation = Label.new(
      "Occupation: %s" % info.occupation, @skin, "status")

    @l_head = Image.new(@mgr.atlas.find_region('status_head'))
    @r_head = Image.new(r_head_tex)
    @l_arm  = Image.new(@mgr.atlas.find_region('status_arm'))
    @torso  = Image.new(@mgr.atlas.find_region('status_torso'))
    @r_arm  = Image.new(r_arm_tex)
    @l_hand = Image.new(@mgr.atlas.find_region('status_hand'))
    @r_hand = Image.new(r_hand_tex)
    @l_leg  = Image.new(@mgr.atlas.find_region('status_leg'))
    @r_leg  = Image.new(r_leg_tex)
    @l_foot = Image.new(@mgr.atlas.find_region('status_foot'))
    @r_foot = Image.new(r_foot_tex)

    @add_info = Label.new(
      "Additional Info\n"\
      "Additional Info\n"\
      "Additional Info\n"\
      "Additional Info\n"\
      "Additional Info",
      @skin, "status")
    @add_info.wrap = true

    @window.add(@name).width(246).height(14).padLeft(4).colspan(4).align(Align::left).row
    @window.add(@occupation).height(11).colspan(4).padLeft(4).padBottom(12).align(Align::left).row
    
    @table_model.add(@l_head).width(13).height(34).padLeft(39).padBottom(3).colspan(2)
    @table_model.add(@r_head).width(13).height(34).padRight(39).padBottom(3).colspan(2).row
    @table_model.add(@l_arm).width(28).height(51).padRight(-7).padLeft(0).padTop(0).colspan(1)
    @table_model.add(@torso).width(39).height(47).padTop(-2).colspan(2)
    @table_model.add(@r_arm).width(28).height(51).padRight(0).padLeft(-7).padTop(0).colspan(1).row
    @table_model.add(@l_hand).width(14).height(14).padRight(14).padTop(-5).padBottom(28).colspan(1)
    @table_model.add(@l_leg).width(24).height(47).padRight(0).padTop(-2).colspan(1)
    @table_model.add(@r_leg).width(24).height(47).padLeft(0).padTop(-2).colspan(1)
    @table_model.add(@r_hand).width(14).height(14).padLeft(14).padTop(-5).padBottom(28).colspan(1).row
    @table_model.add(@l_foot).width(24).height(13).colspan(2).padTop(2).padLeft(18).padRight(7)
    @table_model.add(@r_foot).width(24).height(13).colspan(2).padTop(2).padLeft(7).padRight(18).row

    @window.add(@table_model).width(117).height(140).padLeft(4).align(Align::left).row
    @window.add(@add_info).width(246).padTop(8).padLeft(4)

    @l_head.color = Color.new(1.00, 0.50, 0.50, 1.0)
    @r_head.color = Color.new(1.00, 1.00, 1.00, 1.0)
    @l_arm.color  = Color.new(1.00, 1.00, 1.00, 1.0)
    @torso.color  = Color.new(1.00, 1.00, 1.00, 1.0)
    @r_arm.color  = Color.new(1.00, 0.40, 0.40, 1.0)
    @l_hand.color = Color.new(1.00, 1.00, 1.00, 1.0)
    @l_leg.color  = Color.new(1.00, 1.00, 1.00, 1.0)
    @r_leg.color  = Color.new(1.00, 1.00, 1.00, 1.0)
    @r_hand.color = Color.new(1.00, 1.00, 1.00, 1.0)
    @l_foot.color = Color.new(1.00, 0.20, 0.20, 1.0)
    @r_foot.color = Color.new(1.00, 1.00, 1.00, 1.0)

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