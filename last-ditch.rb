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
		@mgr.add_component(@player, Velocity.new(0, 0))
		@mgr.add_component(@player, Rotation.new(0))
		@mgr.add_component(@player, Inventory.new(C::INVENTORY_SLOTS))
		@mgr.add_component(@player, Needs.new)
		@mgr.add_component(@player, Attributes.new)
		@mgr.add_component(@player, Skills.new)
		@mgr.add_component(@player, UserInput.new)
		@mgr.add_component(@player, Collision.new)
		@mgr.add_component(@player, Animation.new(
			{'player_idle' => ['player_idle1'], 
	     'player_walk' => ['player_idle1',
	                       'player_walk1', 
	                       'player_walk2',
	                       'player_walk1',
	                       'player_idle1', 
	                       "player_walk1-f", 
	                       "player_walk2-f", 
	                       "player_walk1-f"]}))

		@accumulated_dt = 0

		@time      = TimeSystem.new
		@input     = InputSystem.new(@mgr)
		@map       = MapSystem.new(@mgr, @player, @atlas)
		@ui        = UISystem.new(@mgr, @player, @atlas)
		@actions   = ActionsSystem.new(@mgr)
		@inventory = InventorySystem.new(@mgr)
		@equipment = EquipmentSystem.new(@mgr)
		@status    = StatusSystem.new(@mgr)
		@physics   = PhysicsSystem.new(@mgr, @player, @map)
		@render    = RenderSystem.new(@mgr, @player, @atlas)
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

		delta = Gdx.graphics.get_delta_time

		@accumulated_dt += delta

		n_steps = (@accumulated_dt / C::BOX_STEP).floor

		if n_steps > 0
			@accumulated_dt -= n_steps * C::BOX_STEP
		end

		alpha = @accumulated_dt / C::BOX_STEP

		n_steps = [n_steps, C::MAX_STEPS].min

		n_steps.times do

			@time.update
			@map.update
			@actions.update
			@inventory.update
			@equipment.update
			@status.update
			@render.update
			@physics.update
			@ui.update

		end
		
		@physics.world.clear_forces
		# @physics.interpolate(alpha)

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