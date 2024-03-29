class UIStatusSystem < System

  attr_accessor :active, :toggle, :table, :window

  def initialize(mgr, window)
    super()

    @mgr = mgr
    @skin = @mgr.skin
    @active = false
    @window = window

    setup_main
    setup_model
    setup_stats
    setup_attributes

    if 1 == 0
      @table.debug
      @table_male_model.debug
      @table_female_model.debug
    end
  end

  def setup_main
    @table = Table.new
    @table.set_position(560, 44)
    @table.set_size(250, 290)

    info = @mgr.comp(@mgr.player, Info)

    @name = Label.new(
      "Name: %s" % info.name, @skin, "status")
    @occupation = Label.new(
      "Occupation: %s" % info.occupation, @skin, "status")

    @empty = Image.new(@mgr.atlas.find_region('environ/empty'))

    @table.add(@name).
      width(246).height(14).padTop(4).padLeft(4).colspan(4).align(Align::left).row
    @table.add(@occupation).
      height(11).colspan(4).padLeft(4).padBottom(18).align(Align::left).row
  end

  def setup_model
    @table_male_model = Table.new(@skin)

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
    @table_female_model.add(@female_l_hand).padRight(-8).padTop(-71).colspan(1)
    @table_female_model.add(@female_l_arm).padRight(-56).padTop(-43).colspan(1)
    @table_female_model.add(@female_torso).padBottom(0).colspan(2)
    @table_female_model.add(@female_r_arm).padLeft(-64).padTop(-45).colspan(1)
    @table_female_model.add(@female_r_hand).padLeft(-21).padTop(-73).colspan(1).row
    @table_female_model.add(@empty).colspan(2)
    @table_female_model.add(@female_l_leg).padRight(-21).padTop(-3).colspan(1)
    @table_female_model.add(@female_r_leg).padLeft(-25).padTop(1).colspan(1)
    @table_female_model.add(@empty).colspan(2).row
    @table_female_model.add(@empty).colspan(2)
    @table_female_model.add(@female_l_foot).colspan(1).padTop(-10).padLeft(-23)
    @table_female_model.add(@female_r_foot).colspan(1).padTop(-9).padRight(-23)
    @table_female_model.add(@empty).colspan(2).row

    # @table.add(@table_male_model).width(180).height(150).align(Align::left).row
    @table.add(@table_female_model).width(180).height(150).align(Align::left).row
    
  end

  def setup_stats
    @stats_table = Table.new

    @dmg_label = Label.new('Dmg:', @skin, 'status')
    @armor_label = Label.new('Armor:', @skin, 'status')
    @stats_table.add(@dmg_label).row
    @stats_table.add(@armor_label)

    update_stats_list

    @table.add(@stats_table).width(246).padTop(4).padLeft(4)
  end

  def setup_attributes
    @more_info_table = Table.new
    @attributes_table = Table.new
    @skill_table = Table.new

    update_attribute_list

    @more_info_table.add(@attributes_table)
    @table.add(@more_info_table).width(100).padTop(4).padLeft(4)
  end

  def update_stats_list
    stats_c = @mgr.comp(@mgr.player, Stats)

    @dmg_label.text = "Dmg: %s" % stats_c.dmg
    @armor_label.text = "Armor: %s" % stats_c.armor
  end

  def update_attribute_list
    @attributes_table.clear_children

    attributes = @mgr.comp(@mgr.player, Attributes)

    attribute_data = YAML.load_file('cfg/attributes.yml')
    attribute_list = attribute_data['attribute_list']

    for attribute in attribute_list
      lvl = attributes.attributes[attribute] + attributes.modifiers[attribute]

      label = Label.new(
        "%s - %.2f" % [attribute.capitalize, lvl], @skin, "status")
      @attributes_table.add(label).width(120).height(20).row
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
