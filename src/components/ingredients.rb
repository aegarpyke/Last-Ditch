class Ingredients < Component

  attr_accessor :ingredients

  def initialize(ing_list)

    @ingredients = Hash.new

    for ingredient in ing_list
      for type, amt in ingredient
        @ingredients[type] = amt
      end
    end

  end

end