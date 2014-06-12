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

		@accumulated_dt = 0

		@time      = TimeSystem.new
		@input     = InputSystem.new(@mgr)
		@map       = MapSystem.new(@mgr, @player, @atlas)
		@ui        = UISystem.new(@mgr, @player, @atlas)
		@actions   = ActionsSystem.new(@mgr)
		@inventory = InventorySystem.new(@mgr)
		@equipment = EquipmentSystem.new(@mgr)
		@status    = StatusSystem.new(@mgr)
		@ai        = AISystem.new(@mgr)
		@render    = RenderSystem.new(@mgr, @player, @atlas)
		@physics   = PhysicsSystem.new(@mgr, @player, @map)
		@lighting  = LightingSystem.new(@mgr, @map.cam, @physics.world, @physics.player_body)

		@mgr.map       = @map
		@mgr.time      = @time
		@mgr.atlas     = @atlas
		@mgr.actions   = @actions
		@mgr.inventory = @inventory
		@mgr.equipment = @equipment
		@mgr.status    = @status
		@mgr.render    = @render
		@mgr.physics   = @physics
		
		@multiplexer = InputMultiplexer.new
		@multiplexer.add_processor(@ui.stage)
		@multiplexer.add_processor(@input.user_adapter)

		Gdx.input.input_processor = @multiplexer
		Gdx.gl.gl_clear_color(0, 0, 0, 1)

	end


	def set_step


	end


	def render

		delta = Gdx.graphics.delta_time

		@accumulated_dt += delta
		n = (@accumulated_dt / C::BOX_STEP).floor
		@accumulated_dt -= n * C::BOX_STEP if n > 0

		alpha = @accumulated_dt / C::BOX_STEP
	
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

		@map.update
		@ui.update

		@physics.world.clear_forces
		@physics.interpolate(alpha)

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