class Listener < InputListener

  def initialize(mgr)
    super()
    @mgr = mgr
  end

  def keyDown(event, keycode)
    super
    puts keycode
  end

  def enter(event, x, y, pointer, fromActor) 
    super
  end

  def exit(event, x, y, pointer, toActor) 
    super
  end

  def keyTyped(event, character) 
    super
  end
  
  def keyUp(event, keycode) 
    super
  end
  
  def mouseMoved(event, x, y) 
    super
  end
  
  def scrolled(event, x, y, amount) 
    super
  end
  
  def touchDown(event, x, y, pointer, button) 
    super
  end
  
  def touchDragged(event, x, y, pointer) 
    super
  end
  
  def touchUp(event, x, y, pointer, button) 
    super
  end

end