class ActionsSystem < System

  attr_accessor :skill_test_system

	def initialize(mgr, player)

		super()

		@mgr = mgr
    @player = player
    @player_pos = @mgr.comp(@player, Position)
    
    @crafting_system = CraftingSystem.new(mgr)
    @skill_test_system = SkillTestSystem.new(mgr)

    @crafting_system.update
    @skill_test_system.update

	end


	def update

    @crafting_system.update
    @skill_test_system.update

    @skill_test_system.x = @player_pos.x * C::BTW
    @skill_test_system.y = @player_pos.y * C::BTW


	end


	def dispose

	end

end