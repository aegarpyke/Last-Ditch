class CraftingData

  attr_accessor :names

end

class NameData

  attr_accessor :ingredients, :requirements

end

class IngredientData

  attr_accessor :name, :amount

end

class RequirementData

  attr_accessor :name, :level

end