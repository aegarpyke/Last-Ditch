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
      @table_male_model.debug
      @table_female_model.debug

    end

  end


  def setup

    @window = Window.new("Status", @skin, "window1")
    @window.set_position(560, 44)
    @window.set_size(250, 290)
    @window.movable = false
    @window.padTop(9)

    info = @mgr.comp(@mgr.player, Info)

    @name = Label.new(
      "Name: %s" % info.name, @skin, "status")
    @occupation = Label.new(
      "Occupation: %s" % info.occupation, @skin, "status")

    @empty  = Image.new(@mgr.atlas.find_region('environ/empty'))

    @window.add(@name).width(246).height(14).padLeft(4).colspan(4).align(Align::left).row
    @window.add(@occupation).height(11).colspan(4).padLeft(4).padBottom(12).align(Align::left).row

    @table_male_model = Table.new(@skin)

    # @window.add(@table_male_model).width(180).height(160).align(Align::left).row

    @male_l_head = Image.new(@mgr.atlas.find_region('model/male/l_head'))
    @male_r_head = Image.new(@mgr.atlas.find_region('model/male/r_head'))
    @male_l_arm  = Image.new(@mgr.atlas.find_region('model/male/l_arm'))
    @male_torso  = Image.new(@mgr.atlas.find_region('model/male/torso'))
    @male_r_arm  = Image.new(@mgr.atlas.find_region('model/male/r_arm'))
    @male_l_hand = Image.new(@mgr.atlas.find_region('model/male/l_hand'))
    @male_r_hand = Image.new(@mgr.atlas.find_region('model/male/r_hand'))
    @male_l_leg  = Image.new(@mgr.atlas.find_region('model/male/l_leg'))
    @male_r_leg  = Image.new(@mgr.atlas.find_region('model/male/r_leg'))
    @male_l_foot = Image.new(@mgr.atlas.find_region('model/male/l_foot'))
    @male_r_foot = Image.new(@mgr.atlas.find_region('model/male/r_foot'))
    
    @male_l_head.color = Color.new(1.00, 0.50, 0.50, 1.0)
    @male_r_head.color = Color.new(1.00, 1.00, 1.00, 1.0)
    @male_l_arm.color  = Color.new(1.00, 1.00, 1.00, 1.0)
    @male_torso.color  = Color.new(1.00, 1.00, 1.00, 1.0)
    @male_r_arm.color  = Color.new(1.00, 0.40, 0.40, 1.0)
    @male_l_hand.color = Color.new(1.00, 1.00, 1.00, 1.0)
    @male_l_leg.color  = Color.new(1.00, 1.00, 1.00, 1.0)
    @male_r_leg.color  = Color.new(1.00, 1.00, 1.00, 1.0)
    @male_r_hand.color = Color.new(1.00, 1.00, 1.00, 1.0)
    @male_l_foot.color = Color.new(1.00, 0.20, 0.20, 1.0)
    @male_r_foot.color = Color.new(1.00, 1.00, 1.00, 1.0)

    @table_male_model.add(@empty).colspan(2)
    @table_male_model.add(@male_l_head).padLeft(57).padTop(0).colspan(1)
    @table_male_model.add(@male_r_head).padRight(55).padTop(0).colspan(1)
    @table_male_model.add(@empty).colspan(2).row
    @table_male_model.add(@male_l_hand).padRight(-4).padTop(-74).padBottom(0).colspan(1)
    @table_male_model.add(@male_l_arm).padRight(-52).padLeft(0).padTop(-49).colspan(1)
    @table_male_model.add(@male_torso).padTop(0).colspan(2)
    @table_male_model.add(@male_r_arm).padRight(0).padLeft(-58).padTop(-48).colspan(1)
    @table_male_model.add(@male_r_hand).padLeft(-18).padTop(-76).padBottom(0).colspan(1).row
    @table_male_model.add(@empty).colspan(2)
    @table_male_model.add(@male_l_leg).padRight(-26).padTop(0).colspan(1)
    @table_male_model.add(@male_r_leg).padLeft(-17).padTop(-2).colspan(1)
    @table_male_model.add(@empty).colspan(2).row
    @table_male_model.add(@empty).colspan(2)
    @table_male_model.add(@male_l_foot).colspan(1).padTop(-9).padRight(21)
    @table_male_model.add(@male_r_foot).colspan(1).padTop(-12).padLeft(30)
    @table_male_model.add(@empty).colspan(2).row

    @table_female_model = Table.new(@skin)

    @window.add(@table_female_model).width(180).height(160).align(Align::left).row

    @female_l_head = Image.new(@mgr.atlas.find_region('model/female/l_head'))
    @female_r_head = Image.new(@mgr.atlas.find_region('model/female/r_head'))
    @female_l_arm  = Image.new(@mgr.atlas.find_region('model/female/l_arm'))
    @female_torso  = Image.new(@mgr.atlas.find_region('model/female/torso'))
    @female_r_arm  = Image.new(@mgr.atlas.find_region('model/female/r_arm'))
    @female_l_hand = Image.new(@mgr.atlas.find_region('model/female/l_hand'))
    @female_r_hand = Image.new(@mgr.atlas.find_region('model/female/r_hand'))
    @female_l_leg  = Image.new(@mgr.atlas.find_region('model/female/l_leg'))
    @female_r_leg  = Image.new(@mgr.atlas.find_region('model/female/r_leg'))
    @female_l_foot = Image.new(@mgr.atlas.find_region('model/female/l_foot'))
    @female_r_foot = Image.new(@mgr.atlas.find_region('model/female/r_foot'))
    
    @female_l_head.color = Color.new(1.00, 0.50, 0.50, 1.0)
    @female_r_head.color = Color.new(1.00, 1.00, 1.00, 1.0)
    @female_l_arm.color  = Color.new(1.00, 1.00, 1.00, 1.0)
    @female_torso.color  = Color.new(1.00, 1.00, 1.00, 1.0)
    @female_r_arm.color  = Color.new(1.00, 0.40, 0.40, 1.0)
    @female_l_hand.color = Color.new(1.00, 1.00, 1.00, 1.0)
    @female_l_leg.color  = Color.new(1.00, 1.00, 1.00, 1.0)
    @female_r_leg.color  = Color.new(1.00, 1.00, 1.00, 1.0)
    @female_r_hand.color = Color.new(1.00, 1.00, 1.00, 1.0)
    @female_l_foot.color = Color.new(1.00, 0.20, 0.20, 1.0)
    @female_r_foot.color = Color.new(1.00, 1.00, 1.00, 1.0)

    @table_female_model.add(@empty).colspan(2)
    @table_female_model.add(@female_l_head).padLeft(55).padTop(0).colspan(1)
    @table_female_model.add(@female_r_head).padRight(57).padTop(0).colspan(1)
    @table_female_model.add(@empty).colspan(2).row
    @table_female_model.add(@female_l_hand).padRight(-8).padTop(-74).padBottom(0).colspan(1)
    @table_female_model.add(@female_l_arm).padRight(-58).padLeft(0).padTop(-44).colspan(1)
    @table_female_model.add(@female_torso).padBottom(0).colspan(2)
    @table_female_model.add(@female_r_arm).padRight(0).padLeft(-64).padTop(-46).colspan(1)
    @table_female_model.add(@female_r_hand).padLeft(-21).padTop(-75).padBottom(0).colspan(1).row
    @table_female_model.add(@empty).colspan(2)
    @table_female_model.add(@female_l_leg).padRight(-21).padTop(-3).colspan(1)
    @table_female_model.add(@female_r_leg).padLeft(-27).padTop(0).colspan(1)
    @table_female_model.add(@empty).colspan(2).row
    @table_female_model.add(@empty).colspan(2)
    @table_female_model.add(@female_l_foot).colspan(1).padTop(-12).padRight(23)
    @table_female_model.add(@female_r_foot).colspan(1).padTop(-9).padLeft(21)
    @table_female_model.add(@empty).colspan(2).row
    
    @add_info = Label.new(
      "Additional Info\n"\
      "Additional Info\n"\
      "Additional Info\n"\
      "Additional Info\n"\
      "Additional Info",
      @skin, "status")
    @add_info.wrap = true

    @window.add(@add_info).width(246).padTop(8).padLeft(4)

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