class Inventory < Component

  attr_accessor :size, :items, :money, :weight

  def initialize(size)
    super()
    @weight = 0
    @size = size
    @money = 0.34
    @items = Array.new(size)
  end

  def add_money(amount)
    @money += amount
  end

  def remove_money(amount)
    if @money > 0
      @money -= amount
      return true
    else
      return false
    end
  end

end
