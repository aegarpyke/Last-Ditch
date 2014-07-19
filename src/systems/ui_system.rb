class UISystem < System

	attr_accessor :active, :toggle
	attr_accessor :player, :stage, :atlas
	attr_accessor :base, :actions, :inv, :equip, :status
 
	def initialize(mgr, atlas)

		super()
		@mgr = mgr
		@skin = @mgr.skin
		@atlas = atlas
		@mgr.ui = self
		@active = false
		@toggle = false

		@stage = Stage.new

		@base    = UIBaseSystem.new(@mgr, @stage)
		@actions = UIActionsSystem.new(@mgr, @stage)
		@inv     = UIInventorySystem.new(@mgr, @stage)
		@equip   = UIEquipSystem.new(@mgr, @stage)
		@status  = UIStatusSystem.new(@mgr, @stage)

	end


	def update

		@base.update
		@actions.update
		@inv.update
		@equip.update
		@status.update
		
	end


	def activate

		@active = true

		@actions.activate
		@inv.activate
		@equip.activate
		@status.activate

	end


	def deactivate

		@active = false
		@mgr.paused = false

		@actions.deactivate
		@inv.deactivate
		@equip.deactivate
		@status.deactivate

	end


	def toggle_active

		@active = !@active

		if @active

			@actions.activate
			@inv.activate
			@equip.activate
			@status.activate
		
		else

			@mgr.paused = false
			@actions.deactivate
			@inv.deactivate
			@equip.deactivate
			@status.deactivate

		end

	end


	def render

		@stage.act
		@stage.draw

		Table.draw_debug(@stage)

	end

	def dispose


	end

end