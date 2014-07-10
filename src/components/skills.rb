class Skills < Component

	attr_accessor :skills

	def initialize

		super()

    @skills = Hash.new

    skill_data = YAML.load_file('cfg/skills.yml')
    skill_list = skill_data['skill_list']

    for skill in skill_list
      @skills[skill] = 0.12
    end

	end

  def get_level(skill)
    @skills[skill]
  end

  def set_level(skill, level)
    @skills[skill] = level
  end

end