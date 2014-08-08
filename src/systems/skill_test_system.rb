class SkillTestSystem < System

  attr_accessor :active, :testing, :x, :y

  def initialize(mgr)
    @mgr = mgr
    @active = false
    @testing = false

    @x, @y = 0, 0
    @x1, @y1, @x2, @y2 = 0, 0, 0, 0
    
    @R = 110.2
    @r = 42.3
    @d = 22.9
    @theta = 0
    @d_theta = 0.01
    @final_score = 0
    @num_of_hits = 4
    @score_flip = true
    @score_range = 0.12
    @score_min_dist = 0.1
    @num_of_items_to_craft = 0
    @score_label_height_limit = 0
    @hits, @scores, @score_labels = [], [], []

    @effect1 = ParticleEffect.new
    @effect1.load(
      Gdx.files.internal("res/fx/trails_eff1.p"), 
      Gdx.files.internal("res/gfx/ui"))
    @effect2 = ParticleEffect.new
    @effect2.load(
      Gdx.files.internal("res/fx/trails_eff2.p"), 
      Gdx.files.internal("res/gfx/ui"))

    @player_pos = @mgr.comp(@mgr.player, Position)

    calc_hits
  end

  def calc_hits
    count = 0
    theta = 0
    x, px = 0, 0
    prev_hit = -(@score_min_dist + 0.1)

    @hits = []

    while count < @num_of_hits + 2
      px = x
      x = calc_x(theta)

      if (x < 0 && px >= 0) || 
         (x > 0 && px <= 0)
        if theta - prev_hit > @score_min_dist
          count += 1
          prev_hit = theta
          @hits << theta
        end
      end

      theta += @d_theta
    end

    @hits.delete_at(0)    #Removes false positive
  end

  def calc_x(theta)
    dr = @R - @r
    dr * Math.sin(theta)**2 - @d * Math.sin(theta * dr / @r)**2
  end

  def calc_y(theta)
    dr = @R - @r
    dr * Math.cos(theta)**2 + @d * Math.cos(theta * dr / @r)**2
  end

  def score
    if @testing
      goal = false
      lowest_dif = 1000

      for hit in @hits
        dif = (@theta - hit).abs
        lowest_dif = dif if dif < lowest_dif

        if dif < @score_range
          goal = true

          score = (@score_range - dif) * @score_range**-1 
          score = [-1.0, score].max
          @scores << score

          break
        end
      end

      if !goal
        score = (@score_range - lowest_dif) * @score_range**-1 
        score = [-1.0, score].max
        @scores << score
      end

      @score_labels << Label.new(
        "%.2f" % @scores[-1],
        @mgr.skin, 'skills_score')

      @score_flip = !@score_flip
      dx = @score_flip ? 60 : -60

      @score_labels[-1].set_position(
        C::BTW * @player_pos.x + dx, C::BTW * @player_pos.y + 80)
    end
  end

  def finalize
    @testing = false

    @num_of_items_to_craft -= 1

    @final_score = @scores.reduce(:+)
    @final_score /= @hits.size-1

    inv = @mgr.comp(@mgr.player, Inventory)

    station = @mgr.comp(@mgr.actions.cur_station, Station)

    recipe_type = @mgr.comp(@mgr.crafting.cur_recipe, Type)
    ings = @mgr.comp(@mgr.crafting.cur_recipe, Ingredients)

    ing_qualities, ing_conditions = [], []
    res = @mgr.comp(@mgr.actions.cur_station, Resources)

    for ing_type, ing_amt in ings.ingredients
      if ['water', 'energy'].include?(ing_type)
        res.change_amount(ing_type, -ing_amt)
      else
        removed = @mgr.inventory.remove_items_by_type(
          inv, ing_type, ing_amt)

        for item_id in removed
          item = @mgr.comp(item_id, Item)
          ing_qualities << item.quality
          ing_conditions << item.condition
        end
      end
    end

    averaged_quality = ing_qualities.reduce(:+)
    averaged_quality /= ing_qualities.size

    averaged_condition = ing_conditions.reduce(:+)
    averaged_condition /= ing_conditions.size

    if ['water'].include?(recipe_type.type)
      res.change_amount('water', @final_score)
    elsif ['energy1', 'energy2'].include?(recipe_type.type)
      res.change_amount('energy', @final_score)
    else
      item_id = @mgr.inventory.create_inv_item(recipe_type.type)

      item = @mgr.comp(item_id, Item)
      item.quality = averaged_quality * 1.3 * @final_score
      item.condition = averaged_condition

      @mgr.inventory.add_item_by_type(inv, recipe_type.type)
    end
  end

  def activate
    reset

    @active = true
    @testing = true
    @num_of_items_to_craft = @mgr.ui.actions.num_of_craftables
  end

  def deactivate
    reset

    @active = false
    @testing = false
  end

  def reset
    @theta = 0

    @effect1.reset
    @effect2.reset

    @scores = []
    @score_labels = []
    @score_label_height_limit = C::BTW * @player_pos.y + 260

    calc_hits
  end

  def update
    if @active
      if @testing
        if @theta < @hits.last
          @effect1.update(C::BOX_STEP)
          @effect2.update(C::BOX_STEP)

          x = C::BTW * @player_pos.x
          y = C::BTW * @player_pos.y

          @x1, @y1 = calc_x(@theta), calc_y(@theta)
          @x2, @y2 = -@x1, @y1

          @theta += @d_theta

          @effect1.set_position(x + @x1, y + @y1 + 140)
          @effect2.set_position(x + @x2, y + @y2 + 140)
        else
          finalize

          @score_labels << Label.new(
            "Final: %.2f" % @final_score,
            @mgr.skin, 'skills_score')

          @score_labels[-1].set_position(
            C::BTW * @player_pos.x,
            C::BTW * @player_pos.y + 160)
        end
      else
        if @score_labels.empty?
          if @num_of_items_to_craft > 0
            reset
            @testing = true
          else
            @active = false
            @mgr.paused = false
            @mgr.time.active = true

            @mgr.ui.deactivate
          end
        end
      end

      removal_list = []

      for label in @score_labels
        if label.get_y > @score_label_height_limit
          removal_list << label
          next
        end

        if label.get_y > @score_label_height_limit - 20
          label.set_color(
            label.get_color.r, 
            label.get_color.g, 
            label.get_color.b, 
            label.get_color.a - 0.05)
        end

        label.set_position(label.get_x, label.get_y + 1)
      end

      @score_labels -= removal_list
    end
  end

  def render(batch)
    if @active
      batch.begin

      if @testing
        @effect1.draw(batch)
        @effect2.draw(batch)
      end

      for label in @score_labels
        label.draw(batch, 1)
      end

      batch.end
    end
  end

end
