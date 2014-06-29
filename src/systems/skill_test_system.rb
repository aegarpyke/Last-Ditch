class SkillTestSystem < System

  attr_accessor :x, :y

  def initialize(mgr)

    @mgr = mgr
    @x, @y = 0, 0
    @R = 110.2
    @r = 32.3
    @d = 22.9
    @theta = 0
    @d_theta = 0.02

    @effect1 = ParticleEffect.new
    @effect1.load(
      Gdx.files.internal("res/fx/trails_eff1.p"), 
      Gdx.files.internal("res/gfx"))
    
    @effect2 = ParticleEffect.new
    @effect2.load(
      Gdx.files.internal("res/fx/trails_eff2.p"), 
      Gdx.files.internal("res/gfx"))
    
  end


  def calc_x(theta)

    dr = @R - @r
    dr * Math.cos(@theta)**2 + @d * Math.cos(@theta * dr / @r)**3

  end
  
  
  def calc_y(theta)

    dr = @R - @r
    dr * Math.sin(@theta)**3 - @d * Math.sin(@theta * dr / @r)**2

  end


  def update

    @effect1.update(C::BOX_STEP)
    @effect2.update(C::BOX_STEP)

    @theta += @d_theta

    x1, y1 = calc_y(@theta), calc_x(@theta)
    x2, y2 = -x1, y1
    
    @effect1.setPosition(@x + x1, @y + y1 + 140)
    @effect2.setPosition(@x + x2, @y + y2 + 140)

  end


  def render(batch)
    
    @effect1.draw(batch)
    @effect2.draw(batch)

  end

end