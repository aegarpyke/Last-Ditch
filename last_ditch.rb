require 'src/util/initializer'

class LastDitch < Game
	
	def create

		TexturePacker.process('res/gfx', 'res/gfx', 'graphics')

		@mgr = EntityManager.new
		@game_screen = GameScreen.new(@mgr)

		set_screen(@game_screen) 

	end

end

config = LwjglApplicationConfiguration.new
config.title = C::TITLE
config.width, config.height = C::WIDTH, C::HEIGHT
LwjglApplication.new(LastDitch.new, config)