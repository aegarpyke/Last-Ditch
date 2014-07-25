class Equipable < Component

  attr_accessor :types

  def initialize(types)
    
    super()

    @types = []

    for type in types
      @types << type
    end

  end

end














