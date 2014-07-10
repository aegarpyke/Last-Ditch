class UIActionsSystem < System

  attr_accessor :active, :toggle, :window, :recipe_check

  def initialize(mgr, stage, skin)

    super()

    @mgr = mgr
    @stage = stage
    @skin = skin
    @active = true
    @cur_index = 0

    @recipe_check = false

    setup

    if 1 == 0

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
    @station_identifier_label = Label.new('  Station: ', @skin, 'actions')
    @station_label = Label.new('', @skin, 'actions')

    @crafting_info_table.add(@name_label).padLeft(8).align(Align::left).row
    @crafting_info_table.add(@station_identifier_label).padLeft(8).align(Align::left)
    @crafting_info_table.add(@station_label).padLeft(-78).row

    @reqs_and_ings_label_list = []

    10.times do
      
      @reqs_and_ings_label_list << Label.new('', @skin, 'actions')
      @reqs_and_ings_label_list.last.color = Color::GRAY
      
      @crafting_info_table.add(
        @reqs_and_ings_label_list.last).padLeft(8).align(Align::left).row 

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

          @actions.update_action_info
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

          @actions.update_object_info
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


  def update_action_info

    set_station_highlight(false)
    item_selection = @crafting_list.get_selection.to_s
    set_cur_action(item_selection)
    set_recipe_active

  end


  def update_object_info



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

        @recipe_check = true

        set_name(info.name)
        set_station(station)

        @cur_index = 0

        set_reqs(reqs.requirements)
        set_ings(ings.ingredients)

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


  def set_station(station)
    
    if @mgr.actions.cur_station

      current_station = @mgr.comp(@mgr.actions.cur_station, Station)

      if current_station && current_station.type == station.type

        set_station_highlight(true)
      
      else    
      
        @recipe_check = false
        set_station_highlight(false)
      
      end

    else

      @recipe_check = false
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

    @reqs_and_ings_label_list[@cur_index].text = '  Requirements:'
    @reqs_and_ings_label_list[@cur_index].color = Color::WHITE

    @cur_index += 1

    for req, lvl in reqs

      skill_name = skill_data[req]['name']
      skill_lvl  = skills.get_level(req)

      if skill_lvl < lvl
        @recipe_check = false
        @reqs_and_ings_label_list[@cur_index].color = Color::GRAY
      else
        @reqs_and_ings_label_list[@cur_index].color = Color::WHITE
      end

      @reqs_and_ings_label_list[@cur_index].text = "    #{skill_name} #{skill_lvl}/#{lvl}\n"

      @cur_index += 1

    end

    

  end


  def set_ings(ings)

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
            @reqs_and_ings_label_list[@cur_index].color = Color::GRAY
          else
            @reqs_and_ings_label_list[@cur_index].color = Color::WHITE
          end

          @reqs_and_ings_label_list[@cur_index].text = "    #{resource_data[ing]['name']} #{resource_amt}/#{amt}\n"  

        else

          @reqs_and_ings_label_list[@cur_index].text = "    #{resource_data[ing]['name']} 0.0/#{amt}\n"  
          @reqs_and_ings_label_list[@cur_index].color = Color::GRAY

        end

      elsif item_data[ing]
        
        item_amt = @mgr.inventory.item_count(@mgr.player, ing)

        if item_amt < amt
          @recipe_check = false
          @reqs_and_ings_label_list[@cur_index].color = Color::GRAY
        else
          @reqs_and_ings_label_list[@cur_index].color = Color::WHITE
        end

        @reqs_and_ings_label_list[@cur_index].text = "    #{item_data[ing]['name']} #{item_amt}/#{amt}\n"

      else
        raise "Invalid ingredient in recipe: #{ing}"
      end

      @cur_index += 1

    end

    while @cur_index < 10

      @reqs_and_ings_label_list[@cur_index].text = ''
      @cur_index += 1
    
    end

  end


  def switch_focus(focus)

    if focus == :crafting

      @crafting_button.set_checked(true)
      @object_button.set_checked(false)
      @scrollpane.set_widget(@crafting_list)
      @split.set_second_widget(@crafting_info_table)

    elsif focus == :object

      @crafting_button.set_checked(false)
      @object_button.set_checked(true)
      @scrollpane.set_widget(@object_list)
      @split.set_second_widget(@object_info_table)

    end

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