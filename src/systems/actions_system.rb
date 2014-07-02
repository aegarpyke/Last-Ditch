class ActionsSystem < System

  attr_accessor :active, :skill_test_system

	def initialize(mgr, player)

		super()
		@mgr = mgr
    @active = false
    @player = player
    @player_pos = @mgr.comp(@player, Position)
    

	end


	def update

	end


	def dispose

	end

end