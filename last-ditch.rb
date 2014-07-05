require 'src/util/initializer'

class LastDitch < ApplicationAdapter
	
	def create

		TexturePacker.process('res/gfx', 'res/gfx', 'graphics')

		@mgr = EntityManager.new

		@batch = SpriteBatch.new
		@debug = Box2DDebugRenderer.new
		@atlas = TextureAtlas.new(Gdx.files.internal('res/gfx/graphics.atlas'))

		@player = @mgr.create_tagged_entity('player')
		@mgr.add_comp(@player, Position.new(40, 40))
		@mgr.add_comp(@player, Velocity.new(0, 0, C::PLAYER_SPD, C::PLAYER_ROT_SPD))
		@mgr.add_comp(@player, Rotation.new(0))
		@mgr.add_comp(@player, Inventory.new(C::INVENTORY_SLOTS))
		@mgr.add_comp(@player, Needs.new)
		@mgr.add_comp(@player, Attributes.new)
		@mgr.add_comp(@player, Skills.new)
		@mgr.add_comp(@player, UserInput.new)
		@mgr.add_comp(@player, Collision.new)
		@mgr.add_comp(@player, Animation.new(
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
		player_info = @mgr.add_comp(@player, Info.new(
			'Kadijah',
			'This is the player'))
		player_info.occupation = 'Unemployed'

		@drone1 = @mgr.create_tagged_entity('drone 1')
		@mgr.add_comp(@drone1, Position.new(42, 42))
		@mgr.add_comp(@drone1, Velocity.new(0, 0, 0.8, 1))
		@mgr.add_comp(@drone1, Rotation.new(0))
		@mgr.add_comp(@drone1, Collision.new)
		@mgr.add_comp(@drone1, AI.new('wander'))
		@mgr.add_comp(@drone1, Animation.new(
			0.3,
			{'drone1_idle' => ['drone1_idle1',
												 'drone1_idle2']}))

		@drone2 = @mgr.create_tagged_entity('drone 2')
		@mgr.add_comp(@drone2, Position.new(44, 44))
		@mgr.add_comp(@drone2, Velocity.new(0, 0, 1.0, 1))
		@mgr.add_comp(@drone2, Rotation.new(0))
		@mgr.add_comp(@drone2, Collision.new)
		@mgr.add_comp(@drone2, AI.new('wander'))
		@mgr.add_comp(@drone2, Animation.new(
			0.3,
			{'drone1_idle' => ['drone1_idle1',
												 'drone1_idle2']}))

		@timer = 0
		@mgr.atlas = @atlas

		@mgr.time       = @time       = TimeSystem.new
		@mgr.input      = @input      = InputSystem.new(@mgr)

		@mgr.actions    = @actions    = ActionsSystem.new(@mgr, @player)
    @mgr.crafting   = @crafting   = CraftingSystem.new(@mgr)
    @mgr.skill_test = @skill_test = SkillTestSystem.new(@mgr)
    @mgr.inventory  = @inventory  = InventorySystem.new(@mgr, @atlas)
		@mgr.equipment  = @equipment  = EquipmentSystem.new(@mgr)
		@mgr.status     = @status     = StatusSystem.new(@mgr)

    @mgr.ui         = @ui         = UISystem.new(@mgr, @player, @atlas)
    @mgr.inventory.inv_slots = @ui.inv_slots

		@mgr.ai         = @ai         = AISystem.new(@mgr)
		@mgr.map        = @map        = MapSystem.new(@mgr, @player, @atlas)
		@mgr.render     = @render     = RenderSystem.new(@mgr, @player, @atlas)
		@mgr.physics    = @physics    = PhysicsSystem.new(@mgr, @player, @map)
		@mgr.lighting   = @lighting   = LightingSystem.new(@mgr, @map.cam, @physics.world, @physics.player_body)

		@multiplexer = InputMultiplexer.new
		@multiplexer.add_processor(@ui.stage)
		@multiplexer.add_processor(@input.user_adapter)

		Gdx.input.input_processor = @multiplexer
		Gdx.gl.gl_clear_color(0, 0, 0, 1)

	end


	def update

		@timer += Gdx.graphics.delta_time
		n = (@timer / C::BOX_STEP).floor
		@timer -= n * C::BOX_STEP if n > 0

		alpha = @timer / C::BOX_STEP
	
		[n, C::MAX_STEPS].min.times do

			@actions.update
			@crafting.update
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
		# @physics.interpolate(alpha)

	end


	def render

		update

		Gdx.gl.gl_clear(GL20::GL_COLOR_BUFFER_BIT)
		@batch.projection_matrix = @map.cam.combined

		@batch.begin

			@map.render(@batch)
			@render.render(@batch)

		@batch.end

		@lighting.render
		@ui.render

		# if @mgr.paused && @ui.actions_active
		
		# 	@batch.begin
		# 		@actions.skill_test_system.render(@batch)
		# 	@batch.end
		
		# end

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

##########
# Launch #
##########

config = LwjglApplicationConfiguration.new
config.title = C::TITLE
config.width, config.height = C::WIDTH, C::HEIGHT

LwjglApplication.new(LastDitch.new, config)