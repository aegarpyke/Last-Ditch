require 'src/util/initializer'

class LastDitch < ApplicationAdapter
	
	def create

		TexturePacker.process('res/gfx', 'res/gfx', 'graphics')

		@mgr = EntityManager.new

		@batch = SpriteBatch.new
		@debug = Box2DDebugRenderer.new
		@atlas = TextureAtlas.new(Gdx.files.internal('res/gfx/graphics.atlas'))

		@player = @mgr.create_tagged_entity('player')
		@mgr.add_component(@player, Position.new(40, 40))
		@mgr.add_component(@player, Velocity.new(0, 0, C::PLAYER_SPD, C::PLAYER_ROT_SPD))
		@mgr.add_component(@player, Rotation.new(0))
		@mgr.add_component(@player, Inventory.new(C::INVENTORY_SLOTS))
		@mgr.add_component(@player, Needs.new)
		@mgr.add_component(@player, Attributes.new)
		@mgr.add_component(@player, Skills.new)
		@mgr.add_component(@player, UserInput.new)
		@mgr.add_component(@player, Collision.new)
		@mgr.add_component(@player, Animation.new(
			0.1,
			{'player_idle' => ['player_idle1'], 
	     'player_walk' => ['player_idle1',
	                       'player_walk1', 
	                       'player_walk2',
	                       'player_walk1',
	                       'player_idle1', 
	                       "player_walk1-f", 
	                       "player_walk2-f", 
	                       "player_walk1-f"]}))
		player_info = @mgr.add_component(@player, Info.new(
			'Kadijah',
			'This is the player'))
		player_info.occupation = 'Unemployed'


		@droid = @mgr.create_tagged_entity('droid 1')
		@mgr.add_component(@droid, Position.new(42, 42))
		@mgr.add_component(@droid, Velocity.new(0, 0, 0.8, 1))
		@mgr.add_component(@droid, Rotation.new(0))
		@mgr.add_component(@droid, Collision.new)
		@mgr.add_component(@droid, AI.new('wander'))
		@mgr.add_component(@droid, Animation.new(
			0.3,
			{'drone1_idle' => ['drone1_idle1',
												 'drone1_idle2']}))

		@droid2 = @mgr.create_tagged_entity('droid 2')
		@mgr.add_component(@droid2, Position.new(44, 44))
		@mgr.add_component(@droid2, Velocity.new(0, 0, 1.0, 1))
		@mgr.add_component(@droid2, Rotation.new(0))
		@mgr.add_component(@droid2, Collision.new)
		@mgr.add_component(@droid2, AI.new('wander'))
		@mgr.add_component(@droid2, Animation.new(
			0.3,
			{'drone1_idle' => ['drone1_idle1',
												 'drone1_idle2']}))

		@dt_sum = 0
		@mgr.atlas = @atlas

		@mgr.time      = @time      = TimeSystem.new
		@mgr.input     = @input     = InputSystem.new(@mgr)
		@mgr.ui        = @ui        = UISystem.new(@mgr, @player, @atlas)

		@mgr.actions   = @actions   = ActionsSystem.new(@mgr)
		@mgr.inventory = @inventory = InventorySystem.new(@mgr, @atlas)
		@mgr.equipment = @equipment = EquipmentSystem.new(@mgr)
		@mgr.status    = @status    = StatusSystem.new(@mgr)

		@mgr.ai        = @ai        = AISystem.new(@mgr)
		@mgr.map       = @map       = MapSystem.new(@mgr, @player, @atlas)
		@mgr.render    = @render    = RenderSystem.new(@mgr, @player, @atlas)
		@mgr.physics   = @physics   = PhysicsSystem.new(@mgr, @player, @map)
		@mgr.lighting  = @lighting  = LightingSystem.new(@mgr, @map.cam, @physics.world, @physics.player_body)

		@multiplexer = InputMultiplexer.new
		@multiplexer.add_processor(@ui.stage)
		@multiplexer.add_processor(@input.user_adapter)

		Gdx.input.input_processor = @multiplexer
		Gdx.gl.gl_clear_color(0, 0, 0, 1)

	end


	def set_step


	end


	def render

		@dt_sum += Gdx.graphics.delta_time
		n = (@dt_sum / C::BOX_STEP).floor
		@dt_sum -= n * C::BOX_STEP if n > 0

		alpha = @dt_sum / C::BOX_STEP
	
		[n, C::MAX_STEPS].min.times do

			@actions.update
			@inventory.update
			@equipment.update
			@status.update

			unless @mgr.paused
				
				@time.update 
				@ai.update
				@render.update
				@physics.update
			
			end

		end
		
		@physics.world.clear_forces
		# @physics.interpolate(alpha)

		@map.update
		@ui.update

		Gdx.gl.gl_clear(GL20::GL_COLOR_BUFFER_BIT)
		@batch.projection_matrix = @map.cam::combined

		@batch.begin

			@map.render(@batch)
			@render.render(@batch)

		@batch.end

		@lighting.render
		@ui.render

		# @debug.render(@physics.world, @map.cam.combined)

	end


	def dispose

		@batch.dispose
		@time.dispose
		@input.dispose
		@ui.dispose
		@actions.dispose
		@inventory.dispose
		@equipment.dispose
		@status.dispose
		@physics.dispose
		@map.dispose
		@render.dispose
		@lighting.dispose

	end

end

config = LwjglApplicationConfiguration.new
config.title = C::TITLE
config.width, config.height = C::WIDTH, C::HEIGHT
LwjglApplication.new(LastDitch.new, config)