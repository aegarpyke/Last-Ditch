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

				inv = @mgr.get_component(entity, Inventory)
				
				for i in 0...@inv_slots.size

					type = @mgr.get_component(inv.items[i], Type)

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


	def dispose


	end

end