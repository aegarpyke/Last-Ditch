class Equipment < Component

  attr_accessor 'l_head', 'r_head' 
  attr_accessor 'l_hand', 'l_arm', 'torso', 'r_arm', 'r_hand'
  attr_accessor 'l_foot', 'l_leg', 'belt', 'r_leg', 'r_foot'

  def initialize
    super()
  end

  def get_slot(slot_name)
    case slot_name
      when 'l_head'
        return @l_head
      when 'r_head'
        return @r_head
      when 'l_hand'
        return @l_hand
      when 'l_arm'
        return @l_arm
      when 'torso'
        return @torso
      when 'r_arm'
        return @r_arm
      when 'r_hand'
        return @r_hand
      when 'l_foot'
        return @l_foot
      when 'l_leg'
        return @l_leg
      when 'belt'
        return @belt
      when 'r_leg'
        return @r_leg
      when 'r_foot'
        return @r_foot
    end
  end

  def set_slot(slot_name, item_id)
    case slot_name
      when 'l_head'
        @l_head = item_id
      when 'r_head'
        @r_head = item_id
      when 'l_hand'
        @l_hand = item_id
      when 'l_arm'
        @l_arm = item_id
      when 'torso'
        @torso = item_id
      when 'r_arm'
        @r_arm = item_id
      when 'r_hand'
        @r_hand = item_id
      when 'l_foot'
        @l_foot = item_id
      when 'l_leg'
        @l_leg = item_id
      when 'belt'
        @belt = item_id
      when 'r_leg'
        @r_leg = item_id
      when 'r_foot'
        @r_foot = item_id
    end
  end

end
