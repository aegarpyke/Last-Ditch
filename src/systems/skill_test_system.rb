class SkillTestSystem < System

  attr_accessor :active, :testing, :x, :y

  def initialize(mgr)

    @mgr = mgr
    @active = false
    @testing = false

    @x, @y = 0, 0
    @x1, @y1, @x2, @y2 = 0, 0, 0, 0
    
    @R = 110.2
    @r = 32.3
    @d = 22.9
    @theta = 0
    @d_theta = 0.01
    @final_score = 0
    @num_of_hits = 8
    @score_range = 0.12

    @scores = []
    @hits = []

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
    prev_hit = -0.2

    @hits = []

    while count < @num_of_hits + 2

      px = x
      x = calc_x(theta)

      if (x < 0 && px >= 0) || 
         (x > 0 && px <= 0)

        if theta - prev_hit > 0.1
 
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
    dr * Math.sin(theta)**3 - @d * Math.sin(theta * dr / @r)**2

  end


  def calc_y(theta)

    dr = @R - @r
    dr * Math.cos(theta)**2 + @d * Math.cos(theta * dr / @r)**3

  end


  def update

    if @active

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

        @testing = false
        adj_scores = []

        for score in @scores

          adj_score = (@score_range - score) * @score_range**-1 
          adj_score = [-1.0, adj_score].max

          adj_scores << adj_score

        end

        @scores = adj_scores

        @final_score = @scores.inject(:+)
        @final_score /= @hits.size-1

        @mgr.ui.deactivate
        @active = false

      end

    end
  
  end


  def score

    goal = false
    lowest_dif = 1000

    for hit in @hits

      dif = (@theta - hit).abs
      lowest_dif = dif if dif < lowest_dif

      if dif < @score_range

        goal = true
        @scores << dif 

        break

      end
    
    end

    if !goal
      @scores << lowest_dif
    end

  end


  def activate

    reset

    @active = true
    @testing = true

  end


  def deactivate

    @active = false
    @testing = false

  end


  def reset

    @theta = 0
    @scores = []
    calc_hits

  end


  def render(batch)

    if @active
      
      batch.begin

      @effect1.draw(batch)
      @effect2.draw(batch)
    
      batch.end

    end

  end

end