class ActionsSystem < System

  attr_accessor :active, :skill_test_system

	def initialize(mgr, player)

		super()
		@mgr = mgr
    @active = false
    @player = player
    @player_pos = @mgr.comp(@player, Position)
    
    @crafting_system = CraftingSystem.new(mgr)
    @skill_test_system = SkillTestSystem.new(mgr)

	end


	def update

    @crafting_system.update
    @skill_test_system.update

	end


	def dispose

	end

end