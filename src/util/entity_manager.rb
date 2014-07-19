class EntityManager

	attr_accessor :id, :skin
	attr_accessor :render, :physics, :actions, :crafting, :skill_test, :inventory, :equipment, :status
	attr_accessor :player, :physics, :lighting, :input, :ai, :map, :atlas, :ui, :time, :paused

	def initialize

		@paused = false

		@id = java.util.UUID.randomUUID.to_s
		@ids_to_tags = Hash.new
		@tags_to_ids = Hash.new
		@component_stores = Hash.new

	end


	def create_basic_entity

		java.util.UUID.randomUUID.to_s
	
	end


	def create_tagged_entity(human_readable_tag)

		uuid = create_basic_entity

		@ids_to_tags[uuid] = human_readable_tag

		if @tags_to_ids.has_key?(human_readable_tag)
			@tags_to_ids[human_readable_tag] << uuid
		else
			@tags_to_ids[human_readable_tag] = [uuid]
		end

		uuid

	end


	def get_entity(tag)
		@tags_to_ids[tag]
	end


	def get_tag(entity)
		@ids_to_tags[entity]
	end


	def add_comp(entity, component)

		store = @component_stores[component.class]

		if store.nil?
			store = Hash.new
			@component_stores[component.class] = store
		end

		if store.has_key?(entity)
			store[entity] << component unless store[entity].include?(component)
		else
			store[entity] = [component]
		end

		component

	end


	def remove_component(entity, component)

    store = @component_stores[component.class]
    return nil if store.nil?

    components = store[entity]
    return nil if components.nil?
    result = components.delete(component)

    if result.nil?
      raise ArgumentError, "Entity #{entity} has no #{component} to remove"
    else
      store.delete(entity) if store[entity].empty?
      return true
    end
  
  end


  def kill_entity(entity)

    @component_stores.each_value do |store|
      store.delete(entity)
    end

    @tags_to_ids.each_key do |tag|
      if @tags_to_ids[tag].include? entity
        @tags_to_ids[tag].delete entity
      end
    end

    if @ids_to_tags.delete(entity) == nil
      return false
    else
      return true
    end
  
  end


  def comp?(entity, component)

		store = @component_stores[component.class]

		if store.nil?
			return false
		else
			return store.has_key?(entity) && store[entity].include?(component)
		end

	end


	def comp_type?(entity, component_class)

		store = @component_stores[component_class]

		if store.nil?
			return false
		else
			return store.has_key?(entity) && store[entity].size > 0
		end

	end


	def comp(entity, component_class)

		store = @component_stores[component_class]
		
		return nil if store.nil?

		components = store[entity]
		return nil if components.nil? || components.empty?

		if components.size != 1
			raise "Warning: #{entity} has #{components.size} #{component_class.to_s} components."
		end

		components.first

	end


	def comps(entity, component_class)

		store = @component_stores[component_class]

		return nil if store.nil?

		components = store[entity]
		return nil if components.nil? || components.empty?

		components
	
	end


	def entities_with(component_class)

		store = @component_stores[component_class]

		if store.nil?
			return []
		else
			return store.keys
		end
	
	end


	def entities_with_components(component_classes)

		entities = all_entities
		
		component_classes.each do |klass|
			entities = entities & entities_with(klass)
		end

		entities
	
	end


	def all_entities
		@ids_to_tags.keys
	end


	def to_s
		"Entity Manager {#{id}: #{all_entities.size} entities}"
	end

end