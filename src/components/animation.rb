class Animation < Component

  attr_accessor :anims, :duration, :names_and_frames, :cur, :cur_anim, :state_time, :key_frame, :scale

  def initialize(duration, names_and_frames)
    super()
    @scale = 1.0
    @state_time = 0.0
    @anims = Hash.new
    @duration = duration
    @names_and_frames = names_and_frames
  end

  def width
    if key_frame.respond_to?('packedWidth')
      return key_frame.packedWidth
    elsif key_frame.respond_to?('regionWidth')
      return key_frame.regionWidth
    end
  end

  def height
    if key_frame.respond_to?('packedHeight')
      return key_frame.packedHeight
    elsif key_frame.respond_to?('regionHeight')
      return key_frame.regionHeight
    end
  end

  def cur=(name)
    @cur = name
    @cur_anim = @anims[name]
  end

  def key_frame
    @cur_anim.get_key_frame(@state_time, true)
  end

end
