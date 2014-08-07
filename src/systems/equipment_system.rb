class EquipmentSystem < System

  def initialize(mgr)
    super()
    @mgr = mgr
  end

  def equip(entity_id, slot, item_id)
    dequip(entity_id, slot)

    equip = @mgr.comp(entity_id, Equipment)
    equip.set_slot(slot, item_id)               

    attributes = @mgr.comp(entity_id, Attributes)

    if item_id
      item_data = YAML.load_file('cfg/items.yml')
      item_type = @mgr.comp(item_id, Type).type

      if stats = item_data[item_type]['stats']
        for stat, value in stats
          attributes.modifiers[stat] += value
          @mgr.ui.status.update_attribute_list
        end
      end
    end
  end

  def dequip(entity_id, slot)
    equip = @mgr.comp(entity_id, Equipment)
    item_id = equip.get_slot(slot)
    equip.set_slot(slot, nil) 
    
    attributes = @mgr.comp(entity_id, Attributes)

    if item_id
      item_data = YAML.load_file('cfg/items.yml')
      item_type = @mgr.comp(item_id, Type).type

      if stats = item_data[item_type]['stats']
        for stat, value in stats
          attributes.modifiers[stat] -= value
          @mgr.ui.status.update_attribute_list
        end
      end
    end
  end

  def update

  end

  def dispose

  end

end
