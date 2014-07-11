class UISystem < System

	attr_accessor :active, :toggle
	attr_accessor :player, :stage, :atlas
	attr_accessor :base, :actions, :inv, :equip, :status
 
	def initialize(mgr, atlas)

		super()
		@mgr = mgr
		@atlas = atlas
		@mgr.ui = self
		@active = false
		@toggle = false

		@stage = Stage.new
		@skin = Skin.new(Gdx.files.internal('cfg/uiskin.json'), @atlas)

		@base    = UIBaseSystem.new(@mgr, @stage, @skin)
		@actions = UIActionsSystem.new(@mgr, @stage, @skin)
		@inv     = UIInventorySystem.new(@mgr, @stage, @skin)
		@equip   = UIEquipSystem.new(@mgr, @stage, @skin)
		@status  = UIStatusSystem.new(@mgr, @stage, @skin)

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

		@mgr.ui.actions.update_action_info

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