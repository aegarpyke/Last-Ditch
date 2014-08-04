class Equippable < Component

  attr_accessor :slot, :types

  def initialize(types)
    
    super()

    @types = []

    for type in types
      @types << type
    end

    @slot = @types[0]

  end

end














