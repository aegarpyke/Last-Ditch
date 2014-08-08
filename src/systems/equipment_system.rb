class EquipmentSystem < System

  def initialize(mgr)
    super()
    @mgr = mgr
  end

  def equip(entity_id, slot, item_id)
    dequip(entity_id, slot)

    puts @mgr.comp(item_id, Info).name

    equip = @mgr.comp(entity_id, Equipment)
    equip.set_slot(slot, item_id)               

    item_data = YAML.load_file('cfg/items.yml')
    item_type = @mgr.comp(item_id, Type).type

    stats_c = @mgr.comp(entity_id, Stats)

    if stats = item_data[item_type]['stats']
      if dmg = stats['dmg']
        stats_c.dmg = dmg
      end

      if armor = stats['armor']
        stats_c.armor = armor 
      end

      @mgr.ui.status.update_stats_list
    end

    attributes_c = @mgr.comp(entity_id, Attributes)

    if attributes = item_data[item_type]['attributes']
      for attribute, value in attributes
        attributes_c.modifiers[attribute] += value
        @mgr.ui.status.update_attribute_list
      end
    end
  end

  def dequip(entity_id, slot)
    equip = @mgr.comp(entity_id, Equipment)
    
    item_id = equip.get_slot(slot)
    equip.set_slot(slot, nil) 

    if item_id
      item_data = YAML.load_file('cfg/items.yml')
      item_type = @mgr.comp(item_id, Type).type

      stats_c = @mgr.comp(entity_id, Stats)

      if stats = item_data[item_type]['stats']
        if dmg = stats['dmg']
          stats_c.dmg = 0
        end

        if armor = stats['armor'] 
          stats_c.armor = 0
        end

        @mgr.ui.status.update_stats_list
      end

      attributes_c = @mgr.comp(entity_id, Attributes)

      if attributes = item_data[item_type]['attributes']
        for attribute, value in attributes
          attributes_c.modifiers[attribute] -= value
          @mgr.ui.status.update_attribute_list
        end
      end

      return item_id
    end
  end

  def update

  end

  def dispose

  end

end
