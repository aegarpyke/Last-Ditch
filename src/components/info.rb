class Info < Component

  attr_accessor :name, :occupation, :gender, :desc

  def initialize(name)
    super()

    @name = name
    @occupation = 'Unemployed'
    @gender = 'female'
    @desc = ''
  end

end
