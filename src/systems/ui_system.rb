class UISystem < System

	attr_accessor :active, :toggle
	attr_accessor :player, :stage, :atlas
	attr_accessor :base, :actions, :inv, :equip, :status
 
	def initialize(mgr, atlas)

		super()
		@mgr = mgr
		@mgr.ui = self
		@atlas = atlas
		@active = false
		@toggle = false

		@stage = Stage.new
		@skin = Skin.new(Gdx.files.internal('cfg/uiskin.json'), @atlas)

		@table = Table.new(@skin)
		@table.set_bounds(0, 0, C::WIDTH, C::HEIGHT)

		@base    = UIBaseSystem.new(@mgr, @stage, @skin)
		@actions = UIActionsSystem.new(@mgr, @stage, @skin)
		@inv     = UIInventorySystem.new(@mgr, @stage, @skin)
		@equip   = UIEquipSystem.new(@mgr, @stage, @skin)
		@status  = UIStatusSystem.new(@mgr, @stage, @skin)

		if 1 == 0
			
			@table.debug

		end

	end


	def update

		update_view

		@base.update
		@actions.update
		@inv.update
		@equip.update
		@status.update
		
	end


	def update_view

		if @toggle

			@toggle = false
			@active = !@active

			if @active

				@stage.add_actor(@table)
				@stage.add_actor(@actions.window) if @actions.active
				@stage.add_actor(@inv.window)     if @inv.active
				@stage.add_actor(@equip.window)   if @equip.active
				@stage.add_actor(@status.window)  if @status.active
			
			else
			
				@table.remove
				
				@actions.window.remove
				@inv.window.remove
				@equip.window.remove
				@status.window.remove

			end
		
		end

	end


	def render

		if @active || @base.active

			@stage.act
			@stage.draw

			Table.draw_debug(@stage)

		end

	end


	def dispose


	end

end