class Equipment < Component

  attr_accessor 'l_head', 'r_head' 
  attr_accessor 'l_hand', 'l_arm', 'torso', 'r_arm', 'r_hand'
  attr_accessor 'l_foot', 'l_leg', 'belt', 'r_leg', 'r_foot'

  def initialize

    super()

  end


  def get_slot(slot_name)

    if slot_name == 'l_head'
      return @l_head
    elsif slot_name == 'r_head'
      return @r_head
    elsif slot_name == 'l_hand'
      return @l_hand
    elsif slot_name == 'l_arm'
      return @l_arm
    elsif slot_name == 'torso'
      return @torso
    elsif slot_name == 'r_arm'
      return @r_arm
    elsif slot_name == 'r_hand'
      return @r_hand
    elsif slot_name == 'l_foot'
      return @l_foot
    elsif slot_name == 'l_leg'
      return @l_leg
    elsif slot_name == 'belt'
      return @belt
    elsif slot_name == 'r_leg'
      return @r_leg
    elsif slot_name == 'r_foot'
      return @r_foot
    end

  end


  def set_slot(slot_name, item_id)

    if slot_name == 'l_head'
      @l_head = item_id
    elsif slot_name == 'r_head'
      @r_head = item_id
    elsif slot_name == 'l_hand'
      @l_hand = item_id
    elsif slot_name == 'l_arm'
      @l_arm = item_id
    elsif slot_name == 'torso'
      @torso = item_id
    elsif slot_name == 'r_arm'
      @r_arm = item_id
    elsif slot_name == 'r_hand'
      @r_hand = item_id
    elsif slot_name == 'l_foot'
      @l_foot = item_id
    elsif slot_name == 'l_leg'
      @l_leg = item_id
    elsif slot_name == 'belt'
      @belt = item_id
    elsif slot_name == 'r_leg'
      @r_leg = item_id
    elsif slot_name == 'r_foot'
      @r_foot = item_id
    end

  end

end
