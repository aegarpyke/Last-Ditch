require_relative '../../lib/gdx-backend-lwjgl.jar'
require_relative '../../lib/gdx-backend-lwjgl-natives.jar'
require_relative '../../lib/gdx.jar'
require_relative '../../lib/gdx-natives.jar'
require_relative '../../lib/gdx-tools.jar'

java_import com.badlogic.gdx.ApplicationAdapter
java_import com.badlogic.gdx.tools.particleeditor.ParticleEditor
java_import com.badlogic.gdx.backends.lwjgl.LwjglApplication
java_import com.badlogic.gdx.backends.lwjgl.LwjglApplicationConfiguration

class Editor < ApplicationAdapter

  def create
    ParticleEditor.new
  end

end

LwjglApplicationConfiguration.disableAudio = true

config = LwjglApplicationConfiguration.new
config.title = "Particle Editor"


LwjglApplication.new(Editor.new, config)