class Resources < Component

  attr_accessor :water, :energy, :fuel

  def initialize
    super()
    @water = 0.0
    @energy = 0.0
    @fuel = 0.0
  end

  def get_amount(type)
    case type
      when 'water'
        return @water
      when 'energy'
        return @energy
      when 'fuel'
        return @fuel
      else
        raise "Invalid resource type: #{type}"
    end
  end

  def change_amount(type, amount)
    case type
      when 'water'
        @water += amount
      when 'energy'
        @energy += amount
      when 'fuel'
        @fuel += amount
      else
        raise "Invalid resource type: #{type}"
    end
  end

  def set_amount(type, amount)
    case type
      when 'water'
        @water = amount
      when 'energy'
        @energy = amount
      when 'fuel'
        @fuel = amount
      else
        raise "Invalid resource type: #{type}"
    end
  end

end
