class SkillTestSystem < System

  attr_accessor :x, :y

  def initialize(mgr)

    @mgr = mgr
    @x, @y = 0, 0
    @R = 40.2
    @r = 8.3
    @d = 2.2
    @theta = 0
    @adjust = 0.08

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
    (@R - @r) * Math.cos(@theta)**1 +
    @d * Math.cos((@R - @r) * @theta / @r)**1
  end
  
  
  def calc_y(theta)
    (@R - @r) * Math.sin(@theta)**1 - 
    @d * Math.sin((@R - @r) * @theta / @r)**1
  end


  def update

    @effect1.update(C::BOX_STEP)
    @effect2.update(C::BOX_STEP)

    @theta += @adjust
        
    x1, y1 = calc_y(@theta), calc_x(@theta)
    x2, y2 = -x1, y1
    
    @effect1.setPosition(@x + x1, @y + y1)
    @effect2.setPosition(@x + x2, @y + y2)

  end


  def render(batch)
    
    @effect1.draw(batch)
    @effect2.draw(batch)

  end

end