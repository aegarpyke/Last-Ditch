class EquipmentSystem < System

	def initialize(mgr)

		super()
		@mgr = mgr

	end


  def equip(equip, slot, item_id)
    
    equip.set_slot(slot, item_id)               

  end


	def update


	end


	def dispose

	end

end
