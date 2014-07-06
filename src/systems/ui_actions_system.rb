class UIActionsSystem < System

  attr_accessor :active, :toggle, :window

  def initialize(mgr, stage, skin)

    super()

    @mgr = mgr
    @stage = stage
    @skin = skin
    @active = true
    @cur_index = 0

    setup

    if 1 == 0

      @window.debug
      @right.debug
      @left.debug

    end

  end


  def setup

    @window = Window.new(
      "Actions", @skin, "window1")
    @window.set_position(128, 342)
    @window.set_size(548, 254)
    @window.set_movable(false)
    @window.padTop(9)

    @right = Table.new
    @right.align(Align::left | Align::top)

    @name_label = Label.new('Name:', @skin, 'actions')
    @station_label = Label.new('Station:', @skin, 'actions')

    @right.add(@name_label).padLeft(8).align(Align::left).row
    @right.add(@station_label).padLeft(8).align(Align::left).row

    @reqs_and_ings_label_list = []

    10.times do
      
      @reqs_and_ings_label_list << Label.new('', @skin, 'actions')
      @right.add(
        @reqs_and_ings_label_list.last).padLeft(8).align(Align::left).row 

    end

    @left = Table.new
    @left.align(Align::left | Align::top)

    @crafting_list = List.new(@skin, "actions")
    @crafting_list.add_listener(
    
      Class.new(ChangeListener) do

        def initialize(actions)
          super()
          @actions = actions
        end

        def changed(event, actor)

          item_selection = actor.get_selection.to_s
          @actions.set_cur_action(item_selection)

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
          true
        end

      end.new(self))

    @scrollpane = ScrollPane.new(@crafting_list, @skin, "actions")
    @scrollpane.set_overscroll(false, false)
    @scrollpane.set_fade_scroll_bars(false)
    @scrollpane.set_flick_scroll(false)

    crafting_items = GdxArray.new
 
    i = 0
    for name, id in @mgr.crafting.recipes

      i += 1
      info = @mgr.comp(id, Info)
      crafting_items.add("#{i}. #{info.name}")
    
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
        end

      end.new(self))

    @left.add(@crafting_button).height(15).padRight(9)
    @left.add(@object_button).height(15).padRight(130).row
    @left.add(@scrollpane).colspan(2).width(264).height(202).padTop(6)

    @split = SplitPane.new(
      @left, @right,
      false, @skin, "actions_split_pane")

    @window.add(@split).width(540).height(239).padTop(10)

  end


  def set_cur_action(item_selection)

    for type, id in @mgr.crafting.recipes

      info = @mgr.comp(id, Info)

      if item_selection.include?(info.name)

        ings = @mgr.comp(id, Ingredients)
        reqs = @mgr.comp(id, Requirements)
        station = @mgr.comp(id, Station)

        set_name(info.name)
        set_station(station)

        @cur_index = 0

        set_reqs(reqs.requirements)
        set_ings(ings.ingredients)

      end

    end

  end


  def set_name(name)
    @name_label.text = "Name: #{name}"
  end


  def set_station(station)
    
    if @mgr.actions.cur_station

      if @mgr.actions.cur_station == station
        set_station_highlight(true)
      else    
        set_station_highlight(false)
      end

    end

    @station_label.text = "Station: #{station.name}"
  
  end


  def set_station_highlight(highlighted)

    if highlighted
      @station_label.color = Color.new(1.0, 1.0, 1.0, 1.0)
    else
      @station_label.color = Color.new(0.5, 0.5, 0.5, 1.0)
    end

  end


  def set_reqs(reqs)

    skills = @mgr.comp(@mgr.player, Skills)
    skill_data = YAML.load_file('cfg/skills.yml')

    @reqs_and_ings_label_list[@cur_index].text = 'Requirements:'
    @reqs_and_ings_label_list[@cur_index].color = Color.new(1.0, 1.0, 1.0, 1.0)

    @cur_index += 1

    for req, lvl in reqs

      skill_name = skill_data[req]['name']
      skill_lvl = skills.get_level(req)

      if skill_lvl < lvl
        @reqs_and_ings_label_list[@cur_index].color = Color.new(0.5, 0.5, 0.5, 1.0)
      else
        @reqs_and_ings_label_list[@cur_index].color = Color.new(1.0, 1.0, 1.0, 1.0)
      end

      @reqs_and_ings_label_list[@cur_index].text = "  #{skill_name} - #{skill_lvl} / #{lvl}\n"

      @cur_index += 1

    end

    @reqs_and_ings_label_list[@cur_index].text = 'Ingredients:'
    @reqs_and_ings_label_list[@cur_index].color = Color.new(1.0, 1.0, 1.0, 1.0)

    @cur_index += 1

  end


  def set_ings(ings)

    for ing, amt in ings

      item_data = YAML.load_file('cfg/items.yml')
      resource_data = YAML.load_file('cfg/resources.yml')

      if resource_data[ing]

        if @mgr.actions.cur_station

          resources = @mgr.comp(@mgr.actions.cur_station, Resources)
          resource_amt = resources.get_amount(ing)

          if resource_amt < amt
            @reqs_and_ings_label_list[@cur_index].color = Color.new(0.5, 0.5, 0.5, 1.0)
          else
            @reqs_and_ings_label_list[@cur_index].color = Color.new(1.0, 1.0, 1.0, 1.0)
          end

          @reqs_and_ings_label_list[@cur_index].text = "  #{resource_data[ing]['name']} - #{resource_amt} / #{amt}\n"  

        else

          @reqs_and_ings_label_list[@cur_index].text = "  #{resource_data[ing]['name']} - 0.0 / #{amt}\n"  
          @reqs_and_ings_label_list[@cur_index].color = Color.new(1.0, 1.0, 1.0, 1.0)

        end

      elsif item_data[ing]
        
        item_amt = @mgr.inventory.item_count(@mgr.player, ing)

        if item_amt < amt
          @reqs_and_ings_label_list[@cur_index].color = Color.new(0.5, 0.5, 0.5, 1.0)
        else
          @reqs_and_ings_label_list[@cur_index].color = Color.new(1.0, 1.0, 1.0, 1.0)
        end

        @reqs_and_ings_label_list[@cur_index].text = "  #{item_data[ing]['name']} - #{item_amt} / #{amt}\n"

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

    elsif focus == :object

      @crafting_button.set_checked(false)
      @object_button.set_checked(true)
      @scrollpane.set_widget(@object_list)

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