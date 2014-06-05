class GameScreen < ScreenAdapter

	def initialize(mgr)

		super()

		@mgr = mgr
		@batch = SpriteBatch.new
		@atlas = TextureAtlas.new(Gdx.files.internal('res/gfx/graphics.atlas'))

		@player = @mgr.create_tagged_entity('player')
		@mgr.add_component(@player, Position.new(40, 40))
		@mgr.add_component(@player, Velocity.new(0, 0))
		@mgr.add_component(@player, Rotation.new(0))
		@mgr.add_component(@player, Collision.new)
		@mgr.add_component(@player, Needs.new)
		@mgr.add_component(@player, UserInput.new)
		@mgr.add_component(@player, Inventory.new(C::INVENTORY_SLOTS))
		@mgr.add_component(@player, Animation.new(
			{'player_idle' => ['player_idle1'], 
	     'player_walk' => ['player_idle1',
	                       'player_walk1', 
	                       'player_walk2',
	                       'player_walk1',
	                       'player_idle1', 
	                       'player_walk3', 
	                       'player_walk4', 
	                       'player_walk3']}))

		@time      = TimeSystem.new
		@input     = InputSystem.new(@mgr)
		@map       = MapSystem.new(@mgr, @player, @atlas)
		@physics   = PhysicsSystem.new(@mgr, @map)
		@render    = RenderSystem.new(@mgr, @atlas)
		@lighting  = LightingSystem.new(@mgr, @physics.world, @physics.player_body)
		@ui        = UISystem.new(@mgr, @player, @atlas)
		@actions   = ActionsSystem.new(@mgr)
		@inventory = InventorySystem.new(@mgr)
		@equipment = EquipmentSystem.new(@mgr)
		@status    = StatusSystem.new(@mgr)

		@mgr.map       = @map
		@mgr.time      = @time
		@mgr.atlas     = @atlas
		@mgr.actions   = @actions
		@mgr.inventory = @inventory
		@mgr.equipment = @equipment
		@mgr.status    = @status

		@fps = FPSLogger.new
		@debug = Box2DDebugRenderer.new
		
		@multiplexer = InputMultiplexer.new
		@multiplexer.add_processor(@ui.stage)
		@multiplexer.add_processor(@input.user_adapter)

		Gdx.input.input_processor = @multiplexer
		Gdx.gl.gl_clear_color(0, 0, 0, 1)

	end


	def render(delta)

		Gdx.gl.gl_clear(GL20::GL_COLOR_BUFFER_BIT)

		@time.update(delta)
		@input.update(delta)
		@map.update(delta, @batch)
		@physics.update(delta)
		@render.update(delta, @batch)
		@lighting.update(@map.cam.combined)
		@ui.update(delta, @batch)
		@actions.update(delta)
		@inventory.update(delta)
		@equipment.update(delta)
		@status.update(delta)

		# @fps.log
		# @debug.render(@physics.world, @map.cam.combined)

	end


	def dispose

		@batch.dispose
		@time.dispose
		@input.dispose
		@physics.dispose
		@map.dispose
		@render.dispose
		@lighting.dispose
		@ui.dispose
		@actions.dispose
		@inventory.dispose
		@equipment.dispose
		@status.dispose

	end

end