class CraftingSystem < System

  attr_accessor :active, :recipes

  def initialize(mgr)

    @mgr = mgr
    @active = false
    @recipes = Hash.new
    @item_data = YAML.load_file('cfg/items.yml')

    for name, data in @item_data

      unless ['stations', 'items'].include?(name)

        if data["station"]

          recipe = @mgr.create_basic_entity
          
          @mgr.add_comp(recipe, Info.new(data["name"], data["desc"]))
          @mgr.add_comp(recipe, Station.new(data["station"]))
          @mgr.add_comp(recipe, Ingredients.new(data["ingredients"]))
          @mgr.add_comp(recipe, Requirements.new(data["requirements"]))

          @recipes[name] = recipe
        
        end

      end

    end

  end


  def update

  end

end