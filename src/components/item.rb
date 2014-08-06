class Item < Component

  attr_accessor :condition, :quality, :weight, :base_value, :decay_rate, :usable

  def initialize(quality=0.5, condition=1, weight=0.5, base_value=1, usable=false)
    super()

    @usable = usable
    @weight = weight
    @quality = quality
    @condition = condition
    @base_value = base_value
    @decay_rate = 0.01
    @value = @base_value * (2*@quality + 1*@condition)
  end

  def condition=(condition)
    @condition = condition
    @value = @base_value * (2*@quality + 1*@condition)
  end

  def base_value=(base_value)
    @base_value = base_value
    @value = @base_value * (2*@quality + 1*@condition)
  end

  def value
    @value = @base_value * (2*@quality + 1*@condition)
  end

end
