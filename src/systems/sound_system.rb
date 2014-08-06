class SoundSystem < System

  def initialize(mgr, map, render, world)
    super()
    @mgr = mgr
    @map = map
    @render = render
    @world = world
    @player_pos = @map.focus
  end

  def update

  end

  def render

  end

end
