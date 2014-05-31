class InventorySystem < System

	attr_accessor :update

	def initialize(mgr)
		super()
		@mgr = mgr
		@update = true
		@inv_slots = @mgr.ui.inv_slots

	end


	def tick(delta)

		if @update

			@update = false

			entities = @mgr.get_all_entities_with_components([Inventory, UserInput])
			entities.each do |entity|

				inv_comp = @mgr.get_component(entity, Inventory)
				
				for i in 0...@inv_slots.size

					type_comp = @mgr.get_component(inv_comp.items[i], Type)

					if type_comp.nil?

						style = ImageButtonStyle.new(@inv_slots[i].style)
						style.imageUp = nil
						@inv_slots[i].style = style

					else

						style = ImageButtonStyle.new(@inv_slots[i].style)
						style.imageUp = TextureRegionDrawable.new(@mgr.atlas.find_region(type_comp.type))
						@inv_slots[i].style = style

					end

				end

			end

		end

	end

end