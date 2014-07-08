class CraftingSystem < System

  attr_accessor :active, :recipes

  def initialize(mgr)

    @mgr = mgr
    @active = false
    @recipes = Hash.new
    @recipe_data = YAML.load_file('cfg/recipes.yml')

    for recipe_type, data in @recipe_data

      unless recipe_type == 'recipe_list'

        recipe = @mgr.create_basic_entity
        
        info = @mgr.add_comp(recipe, Info.new(data['name']))
        info.desc = data['desc']
        @mgr.add_comp(recipe, Station.new(data['station']))
        @mgr.add_comp(recipe, Ingredients.new(data['ingredients']))
        @mgr.add_comp(recipe, Requirements.new(data['requirements']))

        @recipes[data['name']] = recipe
        
      end

    end

  end


  def update

  end

end