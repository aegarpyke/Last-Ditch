class InventorySystem < System

	attr_accessor :inv_slots, :update_slots

	def initialize(mgr, atlas)

		super()
		@mgr = mgr
		@atlas = atlas
		@update_slots = true
		@item_data = YAML.load_file('cfg/items.yml')

	end


	def update

		if @update_slots

			@update_slots = false

			entities = @mgr.entities_with_components([Inventory, UserInput])
			entities.each do |entity|

				inv = @mgr.comp(entity, Inventory)
				
				for i in 0...@inv_slots.size

					type = @mgr.comp(inv.items[i], Type)

					if type

						style = ImageButtonStyle.new(@inv_slots[i].style)
						tex = TextureRegionDrawable.new(
							@mgr.atlas.find_region("items/#{type.type}"))

						style.imageUp = tex

						@inv_slots[i].style = style
					
					else
						
						style = ImageButtonStyle.new(@inv_slots[i].style)
						tex = TextureRegionDrawable.new(
							@mgr.atlas.find_region('environ/empty'))

						style.imageUp = tex

						@inv_slots[i].style = style 
					
					end

				end

			end

		end

	end


	def destroy_item(item_id)

		info = @mgr.comp(item_id, Info)
		item = @mgr.comp(item_id, Item)

		item.usable = false
		item.condition = 0
		info.desc = 
			"This item is junk. It can only be used "\
			"as scrap at this point."

	end


	def use_item(entity_id, item_id, type_value)

		@update_slots = true
		needs = @mgr.comp(entity_id, Needs)

		case type_value

			when 'rations1'
				type_value = 'rations1_empty'
				needs.hunger = [1, needs.hunger += 0.1].min

			when 'canteen1_water'
				type_value = 'canteen1_empty'
				needs.thirst = [1, needs.thirst += 0.1].min

			when 'canister1_water'
				type_value = 'canister1_empty'
				needs.thirst = [1, needs.thirst += 0.3].min

		end

		type = @mgr.comp(item_id, Type)
		info = @mgr.comp(item_id, Info)
		item = @mgr.comp(item_id, Item)

		type_data = @item_data[type_value]

		type.type = type_value
		info.name = type_data['name']
		info.desc = type_data['desc']
		item.usable = type_data['usable']
		item.weight = type_data['weight']
		item.base_value = type_data['base_value']
		item.condition -= item.decay_rate

		@mgr.inventory.destroy_item(item_id) if item.condition < 0
		@mgr.ui.actions.update_crafting_info

	end


	def create_inv_item(type_value)

		@update_slots = true

		item_id = @mgr.create_basic_entity
		type_data = @item_data[type_value]

		rot    = @mgr.add_comp(item_id, Rotation.new(0))
		type   = @mgr.add_comp(item_id, Type.new(type_value))
		info   = @mgr.add_comp(item_id, Info.new(type_data["name"]))
		info.desc = type_data["desc"]
		
		quality, condition = Random.rand(0.2..0.5), Random.rand(0.1..0.4)

		item = @mgr.add_comp(item_id, Item.new(quality, condition))
		item.base_value = type_data['base_value']
		item.usable = type_data['usable']

		render = Render.new('')
		render.region_name = "items/#{type_value}"
		render.region = @atlas.find_region("items/#{type_value}")
		
		size = @mgr.add_comp(
			item_id, 
			Size.new(render.width * C::WTB, render.height * C::WTB))

		item_id

	end


	def add_item(inv, item_id)

		for i in 0...inv.items.size

			if inv.items[i].nil?

				inv.items[i] = item_id
				return item_id
			
			end

		end

		nil

	end


	def remove_item(inv, item_id)

		index = inv.items.index(item_id)

		if index
			inv.items[index] = nil
			return item_id
		end

		nil

	end


	def remove_items_by_type(inv, type, amt)

		items_to_remove = []

		for item_id in inv.items

			next if item_id.nil?
			
			type_comp = @mgr.comp(item_id, Type)

			if type == type_comp.type
			
				amt -= 1
				items_to_remove << item_id
				break if amt == 0
			
			end

		end

		if amt > 0
		
			return nil
		
		else

			for item_id in items_to_remove

				index = inv.items.index(item_id)
				inv.items[index] = nil
			
			end

			return items_to_remove
		
		end

	end


	def create_item(type_value, x=0, y=0)

		item_id = @mgr.create_basic_entity
		type_data = @item_data[type_value]

		pos    = @mgr.add_comp(item_id, Position.new(x, y))
		rot    = @mgr.add_comp(item_id, Rotation.new(Random.rand(360)))
		type   = @mgr.add_comp(item_id, Type.new(type_value))
		info   = @mgr.add_comp(item_id, Info.new(type_data["name"]))
		info.desc = type_data["desc"]
		
		quality, condition = Random.rand(0.2..0.5), Random.rand(0.1..0.4)

		item = @mgr.add_comp(item_id, Item.new(quality, condition))
		item.base_value = type_data['base_value']
		item.usable = type_data['usable']

		render = @mgr.add_comp(item_id, Render.new(''))
		render.region_name = "items/#{type_value}"
		render.region = @atlas.find_region("items/#{type_value}")
		
		size = @mgr.add_comp(
			item_id, 
			Size.new(render.width * C::WTB, render.height * C::WTB))

		item_id

	end


	def item_count(entity_id, type)
		
		count = 0
		inv = @mgr.comp(entity_id, Inventory)

		for item_id in inv.items

			item_type = @mgr.comp(item_id, Type)

			if item_type && item_type.type == type
				count += 1
			end

		end

		count

	end


	def dispose


	end

end