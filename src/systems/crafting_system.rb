class CraftingSystem < System

  attr_accessor :recipes

  def initialize(mgr)

    @mgr = mgr
    @recipes = Hash.new
    @crafting_data = YAML.load_file('cfg/recipes.yml')

    for name, data in @crafting_data

      recipe = @mgr.create_basic_entity
      
      @mgr.add_comp(recipe, Ingredients.new(data["ingredients"]))
      @mgr.add_comp(recipe, Requirements.new(data["requirements"]))

      @recipes[name] = recipe


    end

  end


  def update

  end

end