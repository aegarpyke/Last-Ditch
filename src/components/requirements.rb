class Requirements < Component

  attr_accessor :requirements

  def initialize(req_list)
    @requirements = Hash.new

    for requirement in req_list
      for type, lvl in requirement
        @requirements[type] = lvl
      end
    end
  end

end
