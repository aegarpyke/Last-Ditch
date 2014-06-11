class InventorySystem < System

	attr_accessor :update_slots

	def initialize(mgr)

		super()
		@mgr = mgr
		@update_slots = true
		@inv_slots = @mgr.ui.inv_slots

	end


	def update

		if @update_slots

			@update_slots = false

			entities = @mgr.get_all_entities_with_components([Inventory, UserInput])
			entities.each do |entity|

				inv_comp = @mgr.get_component(entity, Inventory)
				
				for i in 0...@inv_slots.size

					type_comp = @mgr.get_component(inv_comp.items[i], Type)

					if type_comp

						style = ImageButtonStyle.new(@inv_slots[i].style)
						tex = TextureRegionDrawable.new(
							@mgr.atlas.find_region(type_comp.type))

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


	def dispose


	end

end