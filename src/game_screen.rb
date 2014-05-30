class GameScreen < ScreenAdapter

	def initialize(mgr)

		super()

		@mgr = mgr
		@batch = SpriteBatch.new
		@atlas = TextureAtlas.new(Gdx.files.internal('res/gfx/graphics.atlas'))

		@player = @mgr.create_tagged_entity('player')
		@mgr.add_component(@player, Position.new(3.0, 3.0))
		@mgr.add_component(@player, Velocity.new(0.0))
		@mgr.add_component(@player, Rotation.new(0.0))
		@mgr.add_component(@player, Collision.new)
		@mgr.add_component(@player, Inventory.new(30))
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
		@mgr.add_component(@player, UserInput.new([Keys::W, Keys::A, Keys::S, Keys::D]))
		
		@mgr.atlas = @atlas
		@mgr.map = @map = Map.new(@mgr, C::MAP_WIDTH, C::MAP_HEIGHT)
		@map.focus = @mgr.get_component(@player, Position)

		@input = InputSystem.new(@mgr, @player)
		@physics = PhysicsSystem.new(@mgr)
		@render = RenderSystem.new(@mgr)
		@lighting = LightingSystem.new(
			@mgr, @physics.world, 
			@mgr.get_component(@player, Collision).body)
		@ui = UI.new(@mgr, @player)

		@multiplexer = InputMultiplexer.new
		@multiplexer.add_processor(@ui.stage)
		@multiplexer.add_processor(@input.user_adapter)

		Gdx.input.input_processor = @multiplexer

		@fps = FPSLogger.new
		@debug = Box2DDebugRenderer.new

		Gdx.gl.gl_clear_color(0, 0, 0, 1)

	end


	def render(delta)

		Gdx.gl.gl_clear(GL20::GL_COLOR_BUFFER_BIT)

		@input.tick(delta)

		@physics.tick(delta)
			
		@map.update

		@batch.begin
			@map.render(@batch)
			@render.tick(delta, @batch)
		@batch.end

		@lighting.tick(@map.cam.combined)
		
		@ui.update(delta)
		@ui.render(@batch)

		#########
		# Debug #
		#########

		# @fps.log
		# @debug.render(@physics.world, @map.cam.combined)

	end


	def dispose

		@batch.dispose
		@input.dispose
		@physics.dispose
		@render.dispose
		@lighting.dispose

	end

end