class CraftingSystem < System

  attr_accessor :active, :cur_recipe, :recipes

  def initialize(mgr)
    @mgr = mgr
    @active = false
    @recipes = Hash.new
    @recipe_data = YAML.load_file('cfg/recipes.yml')

    for recipe_type, data in @recipe_data
      unless recipe_type == 'recipe_list'
        recipe = @mgr.create_basic_entity
        
        info = @mgr.add_comp(recipe, Info.new(''))
        info.name = data['name']
        info.desc = data['desc']
        
        @mgr.add_comp(recipe, Type.new(recipe_type))
        @mgr.add_comp(recipe, Station.new(data['station']))
        @mgr.add_comp(recipe, Ingredients.new(data['ingredients']))
        @mgr.add_comp(recipe, Requirements.new(data['requirements']))

        @recipes[recipe_type] = recipe
      end
    end
  end

  def update

  end

end
