class EquipmentSystem < System

	def initialize(mgr)

		super()
		@mgr = mgr

	end


  def equip(equip, item_id)
    
    equipable = @mgr.comp(item_id, Equipable)

    equip.set_slot('l_head', item_id)

  end


	def update


	end


	def dispose

	end

end
