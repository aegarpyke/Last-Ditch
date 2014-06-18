class Action < Component

  attr_accessor :type, :category

  def initialize(type, category)

    super()
    @type = type
    @category = category

  end


  def update

  end

end