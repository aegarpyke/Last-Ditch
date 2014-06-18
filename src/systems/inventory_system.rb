class InventorySystem < System

	attr_accessor :update_slots

	def initialize(mgr, atlas)

		super()
		@mgr = mgr
		@atlas = atlas
		@update_slots = true
		@inv_slots = @mgr.ui.inv_slots

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
							@mgr.atlas.find_region(type.type))

						style.imageUp = tex

						@inv_slots[i].style = style 
					
					else
						
						style = ImageButtonStyle.new(@inv_slots[i].style)
						tex = TextureRegionDrawable.new(
							@mgr.atlas.find_region('empty'))

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
		info.desc = "This item is junk. It can only be used as scrap at this point."

	end


	def use_item(entity_id, item_id, type_value)

		needs = @mgr.comp(entity_id, Needs)

		type = @mgr.comp(item_id, Type)
		info = @mgr.comp(item_id, Info)
		item = @mgr.comp(item_id, Item)
		
		case type_value

			when "rations1"

				needs.hunger = [1, needs.hunger += 0.1].min

				type.type = 'rations1_empty'
			  info.name = "Rations, empty"
			  item.usable = false
			  item.weight = 0.2
			  item.base_value = 0.02
			  item.condition -= item.decay_rate
			  info.desc = 
			  	"An empty rations container. " \
			  	"It can be cleaned and refilled or used as scrap."

			when "canteen1_water"

				needs.thirst = [1, needs.thirst += 0.1].min

				type.type = 'canteen1_empty'
				info.name = 'Canteen, empty'
				item.usable = false
				item.weight = 0.2
				item.base_value = 0.02
				item.condition -= item.decay_rate
				info.desc = 
			  	"This is an empty canteen. It can hold non-corrossive materials."

			when "canister1_water"
				
				needs.thirst = [1, needs.thirst += 0.3].min

				type.type = 'canister1_empty'
				info.name = 'Canister, empty'
				item.usable = false
				item.weight = 0.8
				item.base_value = 0.07
				item.condition -= item.decay_rate
				info.desc =
			  	"This is an empty canteen. It can hold non-corrossive materials."

		end

		@mgr.inventory.destroy_item(item_id) if item.condition < 0

	end


	def create_item(type_value, x=0, y=0)

		item_id = @mgr.create_basic_entity

		quality, condition = Random.rand(0.2..0.5), Random.rand(0.1..0.4)

		pos    = @mgr.add_component(item_id, Position.new(x, y))
		rot    = @mgr.add_component(item_id, Rotation.new(Random.rand(360)))
		info   = @mgr.add_component(item_id, Info.new)
		type   = @mgr.add_component(item_id, Type.new(type_value))
		item   = @mgr.add_component(item_id, Item.new(quality, condition))
		size   = @mgr.add_component(item_id, Size.new(0, 0))
		render = @mgr.add_component(item_id, Render.new(''))

		case type_value

			when "rations1"

				render.region_name = 'rations1'
				render.region = @atlas.find_region('rations1')
				size.width = render.width * C::WTB
				size.height = render.height * C::WTB
				item.usable = true
				item.weight = 0.5
				item.base_value = 0.06
				info.name = 'Rations'
			  info.desc = 
			  	"These are basic rations."

			when "rations1_empty"

				render.region_name = 'rations1_empty'
				render.region = @atlas.find_region('rations1_empty')
				size.width = render.width * C::WTB
				size.height = render.height * C::WTB
				item.weight = 0.2
				item.base_value = 0.02
				info.name = 'Rations, empty'
			  info.desc = 
			  	"This is an empty rations container. It can be " \
			  	"used for scrap or cleaned and refilled."

			when "canteen1_water"

				render.region_name = 'canteen1_water'
				render.region = @atlas.find_region('canteen1_water')
				size.width = render.width * C::WTB
				size.height = render.height * C::WTB
				item.usable = true
				item.weight = 0.6
				item.base_value = 0.07
				info.name = 'Canteen, water'
			  info.desc = 
			  	"This is a canteen of clean drinking water."

		  when "canteen1_empty"

				render.region_name = 'canteen1_empty'
				render.region = @atlas.find_region('canteen1_empty')
				size.width = render.width * C::WTB
				size.height = render.height * C::WTB
				item.weight = 0.2
				item.base_value = 0.02
				info.name = 'Canteen, empty'
			  info.desc = 
			  	"This is an empty canteen. It can be refilled " \
			  	"or used for scrap."

			when "canister1_empty"

				render.region_name = 'canister1_empty'
				render.region = @atlas.find_region('canister1_empty')
				size.width = render.width * C::WTB
				size.height = render.height * C::WTB
				item.weight = 0.8
				item.base_value = 0.07
				info.name = 'Canister, empty'
			  info.desc = 
			  	"This is an empty canister. It can hold corrosive materials."

			when "canister1_water"

				render.region_name = 'canister1_water'
				render.region = @atlas.find_region('canister1_water')
				size.width = render.width * C::WTB
				size.height = render.height * C::WTB
				item.usable = true
				item.weight = 1.4
				item.base_value = 0.21
				info.name = 'Canister, water'
			  info.desc = 
			  	"This is a canister of drinking water."

			when "canister1_waste"

				render.region_name = 'canister1_waste'
				render.region = @atlas.find_region('canister1_waste')
				size.width = render.width * C::WTB
				size.height = render.height * C::WTB
				item.weight = 1.6
				item.base_value = 0.09
				info.name = 'Canister, waste'
			  info.desc = 
			  	"This is canister of waste. It can be used to produce energy, " \
			  	"chemicals, or gases."

			when "canister1_fuel"

				render.region_name = 'canister1_fuel'
				render.region = @atlas.find_region('canister1_fuel')
				size.width = render.width * C::WTB
				size.height = render.height * C::WTB
				item.weight = 1.3
				item.base_value = 0.34
				info.name = 'Canister, fuel'
			  info.desc = 
			  	"This is a canister of fuel."

			when 'handgun1'

				render.region_name = 'handgun1'
				render.region = @atlas.find_region('handgun1')
				size.width = render.width * C::WTB
				size.height = render.height * C::WTB
				item.weight = 0.36
				item.base_value = 0.54
				info.name = 'Handgun'
			  info.desc = 
			  	"This is a handgun."

			when 'scrap1'

				render.region_name = 'scrap1'
				render.region = @atlas.find_region('scrap1')
				size.width = render.width * C::WTB
				size.height = render.height * C::WTB
				item.weight = 1.4
				item.base_value = 0.10
				info.name = 'Scrap'
			  info.desc = 
			  	"This is a piece of scrap that contains pieces of plastic and metal."			

			when "overgrowth1"

				render.region_name = 'overgrowth1'
				render.region = @atlas.find_region('overgrowth1')
				size.width = render.width * C::WTB
				size.height = render.height * C::WTB
				item.weight = 0.4
				item.base_value = 0.01
				info.name = 'Overgrowth'
			  info.desc = 
			  	"This is the roots of some overgrowth. It can be " \
			  	"burned for energy."

			when "ruffage1"

				render.region_name = 'ruffage1'
				render.region = @atlas.find_region('ruffage1')
				size.width = render.width * C::WTB
				size.height = render.height * C::WTB
				item.weight = 0.2
				item.base_value = 0.005
				info.name = 'Ruffage'
			  info.desc = 
			  	"These are stray roots and vines from some overgrowth."

		end

		item_id

	end


	def dispose


	end

end