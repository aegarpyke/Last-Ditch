class UIActionsSystem < System

  attr_accessor :active, :focus, :toggle, :window, :recipe_check

  def initialize(mgr, stage)

    super()

    @mgr = mgr
    @skin = @mgr.skin
    @stage = stage
    @cur_index = 0
    @focus = :crafting
    @prev_selection = nil
    @active = false
    @recipe_check = false
    @tot_num_of_craftables = 0

    setup

    if 1 == 1

      @window.debug
      @crafting_info_table.debug
      @object_info_table.debug

    end

  end


  def setup

    @window = Window.new(
      "Actions", @skin, "window1")
    @window.set_position(128, 342)
    @window.set_size(548, 254)
    @window.set_movable(false)
    @window.padTop(9)

    @crafting_info_table = Table.new
    @crafting_info_table.align(Align::left | Align::top)

    @name_label = Label.new('Name:', @skin, 'actions_title')
    @craftables_left_arrow_button = Button.new(@skin, 'actions_left_arrow_button')
    @craftables_label = Label.new('', @skin, 'actions')
    @craftables_label.set_alignment(Align::right)
    @craftables_right_arrow_button = Button.new(@skin, 'actions_right_arrow_button')
    @station_identifier_label = Label.new('  Station: ', @skin, 'actions')
    @station_label = Label.new('', @skin, 'actions')
    @station_label.set_alignment(Align::left)

    @crafting_info_table.add(@name_label).width(120).padLeft(8).align(Align::left)
    @crafting_info_table.add(@craftables_left_arrow_button)
    @crafting_info_table.add(@craftables_label).align(Align::right)
    @crafting_info_table.add(@craftables_right_arrow_button).row
    @crafting_info_table.add(@station_identifier_label).width(50).padLeft(8).align(Align::left)
    @crafting_info_table.add(@station_label).width(120).align(Align::left).padLeft(-30).row

    @reqs_and_ings_label_list = []

    10.times do
      
      @reqs_and_ings_label_list << Label.new('', @skin, 'actions')
      @reqs_and_ings_label_list.last.color = Color::GRAY
      
      @crafting_info_table.add(
        @reqs_and_ings_label_list.last).colspan(2).padLeft(8).align(Align::left).row 

    end

    @object_info_table = Table.new
    @object_info_table.align(Align::left | Align::top)

    @actions_list_table = Table.new
    @actions_list_table.align(Align::left | Align::top)

    @crafting_list = List.new(@skin, "actions")
    @crafting_list.add_listener(
    
      Class.new(ChangeListener) do

        def initialize(actions)

          super()
          @actions = actions
        
        end

        def changed(event, actor)

          @actions.activate_skill_system
          true

        end

      end.new(self))
    
    @object_list = List.new(@skin, "actions")
    @object_list.add_listener(
    
      Class.new(ChangeListener) do

        def initialize(actions)

          super()
          @actions = actions
        
        end

        def changed(event, actor)

          @actions.activate_skill_system
          true

        end

      end.new(self))

    @scrollpane = ScrollPane.new(@crafting_list, @skin, "actions")
    @scrollpane.set_overscroll(false, false)
    @scrollpane.set_fade_scroll_bars(false)
    @scrollpane.set_flick_scroll(false)

    crafting_items = GdxArray.new
 
    for name, id in @mgr.crafting.recipes

      info = @mgr.comp(id, Info)
      crafting_items.add("#{info.name}")
    
    end

    @crafting_list.set_items(crafting_items)

    object_items = GdxArray.new

    @object_list.set_items(object_items)

    @crafting_button = TextButton.new(
      "Crafting", @skin, "actions_button")
    @crafting_button.set_checked(true)
    
    @object_button = TextButton.new(
      "Object", @skin, "actions_button")

    @crafting_button.add_listener(

      Class.new(ClickListener) do

        def initialize(actions)

          super()
          @actions = actions
        
        end

        def clicked(event, x, y)
          
          @actions.switch_focus(:crafting)
          true
        
        end

      end.new(self))

    @object_button.add_listener(

      Class.new(ClickListener) do 

        def initialize(actions)

          super()
          @actions = actions
        
        end

        def clicked(event, x, y)
        
          @actions.switch_focus(:object)       
          true

        end

      end.new(self))

    @actions_list_table.add(@crafting_button).height(15).padRight(9)
    @actions_list_table.add(@object_button).height(15).padRight(130).row
    @actions_list_table.add(@scrollpane).colspan(2).width(264).height(202).padTop(6)

    @split = SplitPane.new(
      @actions_list_table, @crafting_info,
      false, @skin, "actions_split_pane")

    @window.add(@split).width(540).height(239).padTop(10)

    switch_focus(:crafting)

  end


  def activate_skill_system

    if @focus == :crafting

      update_crafting_info

      if @recipe_check && @crafting_list.get_selection.first == @prev_selection

        deactivate
        @mgr.skill_test.activate

      end

      @prev_selection = @crafting_list.get_selection.first

    elsif @focus == :object

      update_object_info

    end

  end


  def set_recipe_active

    if @recipe_check
      set_name_highlight(true)
    else
      set_name_highlight(false)
    end

  end


  def set_cur_action(item_selection)

    for type, id in @mgr.crafting.recipes

      info = @mgr.comp(id, Info)

      if item_selection.include?(info.name)

        ings = @mgr.comp(id, Ingredients)
        reqs = @mgr.comp(id, Requirements)
        station = @mgr.comp(id, Station)

        @cur_index = 0
        @recipe_check = true
        @tot_num_of_craftables = 1000
        @mgr.crafting.cur_recipe = id

        set_name(info.name)
        set_station(station)
        set_reqs(reqs.requirements)
        set_ings(ings.ingredients)

        set_num_of_craftables

      end

    end

  end


  def set_name(name)
    @name_label.text = "#{name}"
  end


  def set_name_highlight(highlighted)

    if highlighted
      @name_label.color = Color::WHITE
    else
      @name_label.color = Color::GRAY
    end

  end


  def set_num_of_craftables

    @craftables_label.text = "0 / %d" % @tot_num_of_craftables

  end


  def set_station(station)
    
    if @mgr.actions.cur_station

      current_station = @mgr.comp(@mgr.actions.cur_station, Station)

      if current_station && current_station.type == station.type

        set_station_highlight(true)
      
      else    
      
        @recipe_check = false
        @tot_num_of_craftables = 0
        set_station_highlight(false)
      
      end

    else

      @recipe_check = false
      @tot_num_of_craftables = 0
      set_station_highlight(false)

    end

    @station_label.text = "#{station.name}"
  
  end


  def set_station_highlight(highlighted)

    if highlighted
      @station_label.color = Color::WHITE
    else
      @station_label.color = Color::GRAY
    end

  end


  def set_reqs(reqs)

    skills = @mgr.comp(@mgr.player, Skills)
    skill_data = YAML.load_file('cfg/skills.yml')

    @reqs_and_ings_label_list[@cur_index].text = '  Skills:'
    @reqs_and_ings_label_list[@cur_index].color = Color::WHITE

    @cur_index += 1

    for req, lvl in reqs

      skill_name  = skill_data[req]['name']
      display_lvl = (lvl * 100).to_i
      skill_lvl   = (skills.get_level(req) * 100).to_i

      if skill_lvl < display_lvl

        @recipe_check = false
        @tot_num_of_craftables = 0
        @reqs_and_ings_label_list[@cur_index].color = Color::GRAY
        
      else
      
        @reqs_and_ings_label_list[@cur_index].color = Color::WHITE
      
      end

      txt = "    - %s %d / %d" % [skill_name.uncapitalize, skill_lvl, display_lvl]
      @reqs_and_ings_label_list[@cur_index].text = txt

      @cur_index += 1

    end

  end


  def set_ings(ings)

    num_of_craftables = 0

    @reqs_and_ings_label_list[@cur_index].text = '  Ingredients:'
    @reqs_and_ings_label_list[@cur_index].color = Color::WHITE

    @cur_index += 1

    for ing, amt in ings

      item_data     = YAML.load_file('cfg/items.yml')
      resource_data = YAML.load_file('cfg/resources.yml')

      if resource_data[ing]

        if @mgr.actions.cur_station

          resources = @mgr.comp(@mgr.actions.cur_station, Resources)
          resource_amt = resources.get_amount(ing)

          if resource_amt < amt

            @recipe_check = false
            num_of_craftables = 0
            @reqs_and_ings_label_list[@cur_index].color = Color::GRAY
          
          else

            num_of_craftables = (resource_amt / amt).to_i
            @reqs_and_ings_label_list[@cur_index].color = Color::WHITE

          end

          if num_of_craftables < @tot_num_of_craftables
            @tot_num_of_craftables = num_of_craftables
          end

          txt = "    - %s %.1f / %.1f" % [resource_data[ing]['name'].uncapitalize, resource_amt, amt]  
          @reqs_and_ings_label_list[@cur_index].text = txt

        else

          txt = "    - %s 0.0 / %.1f" % [resource_data[ing]['name'].uncapitalize, amt]
          @reqs_and_ings_label_list[@cur_index].text = txt
          @reqs_and_ings_label_list[@cur_index].color = Color::GRAY

        end

      elsif item_data[ing]
        
        item_amt = @mgr.inventory.item_count(@mgr.player, ing)

        if item_amt < amt
        
          @recipe_check = false
          num_of_craftables = 0
          @reqs_and_ings_label_list[@cur_index].color = Color::GRAY
        
        else

          num_of_craftables = (item_amt / amt).to_i
          @reqs_and_ings_label_list[@cur_index].color = Color::WHITE
        
        end

        if num_of_craftables < @tot_num_of_craftables
          @tot_num_of_craftables = num_of_craftables
        end

        txt = "    - %s %d / %d" % [item_data[ing]['name'].uncapitalize, item_amt, amt]
        @reqs_and_ings_label_list[@cur_index].text = txt

      else
        raise "Invalid ingredient in recipe: #{ing}"
      end

      if !@recipe_check
        @tot_num_of_craftables = 0
      end


      @cur_index += 1

    end

    while @cur_index < 10

      @reqs_and_ings_label_list[@cur_index].text = ''
      @cur_index += 1
    
    end

  end


  def switch_focus(focus)

    @focus = focus

    if @focus == :crafting

      @crafting_button.set_checked(true)
      @object_button.set_checked(false)
      @scrollpane.set_widget(@crafting_list)
      @split.set_second_widget(@crafting_info_table)

    elsif @focus == :object

      @crafting_button.set_checked(false)
      @object_button.set_checked(true)
      @scrollpane.set_widget(@object_list)
      @split.set_second_widget(@object_info_table)

    end

  end


  def update


  end


  def update_crafting_info

    set_station_highlight(false)
    item_selection = @crafting_list.get_selection.to_s
    set_cur_action(item_selection)
    set_recipe_active

  end


  def update_object_info



  end


  def activate

    @active = true
    @mgr.ui.active = true
    @stage.add_actor(@window)

    update_crafting_info

  end


  def deactivate

    @active = false
    @window.remove

  end


  def toggle_active
    
    @active = !@active

    if @active
      @stage.add_actor(@window)
      update_crafting_info
    else
      @window.remove
    end

  end

end