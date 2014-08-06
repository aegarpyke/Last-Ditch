class Room < Component

  attr_accessor :x, :y, :x1, :y1, :x2, :y2, :width, :height

  def initialize(x, y, width, height)
    super()
    @width, @height = width, height

    @x1 = @x = x
    @y1 = @y = y
    @x2 = @x + @width
    @y2 = @y + @height
  end

  def intersects(x1, y1, x2, y2)
    !(@x2 < x1 || x2 < @x1 || @y2 < y1 || y2 < @y1)
  end

  def expand(rooms, master)
    direction = Random.rand(4)

    check = false
    rooms.each do |room|
      next if room == self

      case direction
        when 0
          if room.intersects(@x1 - 1, @y1, @x2, @y2) || @x1 - 1 < master.x1
            check = true
          end
        when 1
          if room.intersects(@x1, @y1 - 1, @x2, @y2) || @y1 - 1 < master.y1
            check = true
          end
        when 2
          if room.intersects(@x1, @y1, @x2 + 1, @y2) || @x2 + 1 > master.x2
            check = true
          end
        when 3
          if room.intersects(@x1, @y1, @x2, @y2 + 1) || @y2 + 1 > master.y2
            check = true
          end
      end
    end

    if check == false
      case direction
        when 0
          @x1 -= 1
        when 1
          @y1 -= 1
        when 2
          @x2 += 1
        when 3
          @y2 += 1
      end
    end
  end

  def x=(value)
    @x1 = @x = value
  end

  def y=(value)
    @y1 = @y = value
  end

  def x1=(value)
    @x1 = @x = value
  end

  def y1=(value)
    @y1 = @y = value
  end

  def x2=(value)
    @x2 = x2
    @width = @x2 - @x1
  end

  def y2=(value)
    @y2 = y2
    @height = @y2 - @y1
  end

  def width=(value)
    @width = value
    @x2 = @x1 + value
  end

  def height=(value)
    @height = value
    @y2 = @y1 + value
  end

end
