class Equipable < Component

  attr_accessor :type, :types

  def initialize(types)
    
    super()

    @types = []

    for type in types
      @types << type
    end

    @type = @types[0]
  end

end














