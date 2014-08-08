class Stats < Component
  
  attr_accessor :dmg, :armor

  def initialize
    super()
    @dmg = 0
    @armor = 0
  end

end
