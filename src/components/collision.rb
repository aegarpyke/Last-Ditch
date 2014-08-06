class Collision < Component

  attr_accessor :body

  def initialize(body=nil)
    super()
    @body = body
  end

end
