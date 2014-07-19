require 'java'
require 'yaml'

require_relative '../../lib/gdx-backend-lwjgl.jar'
require_relative '../../lib/gdx-backend-lwjgl-natives.jar'
require_relative '../../lib/gdx.jar'
require_relative '../../lib/gdx-natives.jar'
require_relative '../../lib/gdx-box2d.jar'
require_relative '../../lib/gdx-box2d-natives.jar'
require_relative '../../lib/gdx-tools.jar'
require_relative '../../lib/box2dlights-1.3-SNAPSHOT.jar'

java_import com.badlogic.gdx.Gdx
java_import com.badlogic.gdx.Input
java_import com.badlogic.gdx.Input::Keys
java_import com.badlogic.gdx.ScreenAdapter
java_import com.badlogic.gdx.ApplicationAdapter
java_import com.badlogic.gdx.InputAdapter
java_import com.badlogic.gdx.InputMultiplexer
java_import com.badlogic.gdx.InputProcessor
java_import com.badlogic.gdx.utils.TimeUtils
java_import com.badlogic.gdx.utils.Pool
java_import com.badlogic.gdx.utils.Json
java_import com.badlogic.gdx.utils.JsonWriter
java_import com.badlogic.gdx.utils.JsonWriter::OutputType
java_import com.badlogic.gdx.math.Vector2
java_import com.badlogic.gdx.math.Rectangle
java_import com.badlogic.gdx.graphics.GL20
java_import com.badlogic.gdx.graphics.Texture
java_import com.badlogic.gdx.graphics.OrthographicCamera
java_import com.badlogic.gdx.graphics.Color
java_import com.badlogic.gdx.graphics.g2d.SpriteBatch
java_import com.badlogic.gdx.graphics.g2d.TextureAtlas
java_import com.badlogic.gdx.graphics.g2d.TextureRegion
java_import com.badlogic.gdx.graphics.g2d.BitmapFont
java_import com.badlogic.gdx.graphics.g2d.NinePatch
java_import com.badlogic.gdx.graphics.g2d.BitmapFont::TextBounds
java_import com.badlogic.gdx.graphics.g2d.ParticleEffect
java_import com.badlogic.gdx.physics.box2d.World
java_import com.badlogic.gdx.physics.box2d.Body
java_import com.badlogic.gdx.physics.box2d.BodyDef
java_import com.badlogic.gdx.physics.box2d.Fixture
java_import com.badlogic.gdx.physics.box2d.FixtureDef
java_import com.badlogic.gdx.physics.box2d.BodyDef::BodyType
java_import com.badlogic.gdx.physics.box2d.PolygonShape
java_import com.badlogic.gdx.physics.box2d.CircleShape
java_import com.badlogic.gdx.physics.box2d.Box2DDebugRenderer
java_import com.badlogic.gdx.physics.box2d.RayCastCallback
java_import com.badlogic.gdx.scenes.scene2d.InputListener
java_import com.badlogic.gdx.scenes.scene2d.InputEvent
java_import com.badlogic.gdx.scenes.scene2d.Stage
java_import com.badlogic.gdx.scenes.scene2d.ui.Skin
java_import com.badlogic.gdx.scenes.scene2d.ui.Table
java_import com.badlogic.gdx.scenes.scene2d.ui.Button
java_import com.badlogic.gdx.scenes.scene2d.ui.Button::ButtonStyle
java_import com.badlogic.gdx.scenes.scene2d.ui.List
java_import com.badlogic.gdx.scenes.scene2d.ui.List::ListStyle
java_import com.badlogic.gdx.scenes.scene2d.ui.Image
java_import com.badlogic.gdx.scenes.scene2d.ui.ImageButton
java_import com.badlogic.gdx.scenes.scene2d.ui.ImageButton::ImageButtonStyle
java_import com.badlogic.gdx.scenes.scene2d.ui.TextButton
java_import com.badlogic.gdx.scenes.scene2d.ui.TextButton::TextButtonStyle
java_import com.badlogic.gdx.scenes.scene2d.ui.Label
java_import com.badlogic.gdx.scenes.scene2d.ui.Label::LabelStyle
java_import com.badlogic.gdx.scenes.scene2d.ui.Window
java_import com.badlogic.gdx.scenes.scene2d.ui.Window::WindowStyle
java_import com.badlogic.gdx.scenes.scene2d.ui.SplitPane
java_import com.badlogic.gdx.scenes.scene2d.ui.SplitPane::SplitPaneStyle
java_import com.badlogic.gdx.scenes.scene2d.ui.ProgressBar
java_import com.badlogic.gdx.scenes.scene2d.ui.ProgressBar::ProgressBarStyle
java_import com.badlogic.gdx.scenes.scene2d.ui.ScrollPane
java_import com.badlogic.gdx.scenes.scene2d.ui.ScrollPane::ScrollPaneStyle
java_import com.badlogic.gdx.scenes.scene2d.utils.Align
java_import com.badlogic.gdx.scenes.scene2d.utils.ClickListener
java_import com.badlogic.gdx.scenes.scene2d.utils.ChangeListener
java_import com.badlogic.gdx.scenes.scene2d.utils.NinePatchDrawable
java_import com.badlogic.gdx.scenes.scene2d.utils.TextureRegionDrawable
java_import com.badlogic.gdx.backends.lwjgl.LwjglApplication
java_import com.badlogic.gdx.backends.lwjgl.LwjglApplicationConfiguration
java_import com.badlogic.gdx.tools.texturepacker.TexturePacker

java_import 'box2dLight.RayHandler'
java_import 'box2dLight.Light'
java_import 'box2dLight.PointLight'
java_import 'box2dLight.ConeLight'
java_import 'box2dLight.DirectionalLight'

require_relative 'c'
require_relative 'user_adapter'
require_relative 'entity_manager'
require_relative 'ray_cast_callback_impl'
require_relative '../systems/system'
require_relative '../systems/time_system'
require_relative '../systems/input_system'
require_relative '../systems/physics_system'
require_relative '../systems/render_system'
require_relative '../systems/lighting_system'
require_relative '../systems/map_system'
require_relative '../systems/ui_system'
require_relative '../systems/ui_base_system'
require_relative '../systems/ui_actions_system'
require_relative '../systems/ui_equip_system'
require_relative '../systems/ui_status_system'
require_relative '../systems/ui_inventory_system'
require_relative '../systems/actions_system'
require_relative '../systems/inventory_system'
require_relative '../systems/equipment_system'
require_relative '../systems/status_system'
require_relative '../systems/ai_system'
require_relative '../systems/sound_system'
require_relative '../systems/crafting_system'
require_relative '../systems/skill_test_system'
require_relative '../components/component'
require_relative '../components/info'
require_relative '../components/type'
require_relative '../components/room'
require_relative '../components/door'
require_relative '../components/size'
require_relative '../components/position'
require_relative '../components/velocity'
require_relative '../components/rotation'
require_relative '../components/animation'
require_relative '../components/render'
require_relative '../components/collision'
require_relative '../components/user_input'
require_relative '../components/item'
require_relative '../components/inventory'
require_relative '../components/needs'
require_relative '../components/skills'
require_relative '../components/attributes'
require_relative '../components/station'
require_relative '../components/ai'
require_relative '../components/station'
require_relative '../components/ingredients'
require_relative '../components/requirements'
require_relative '../components/resources'

GdxArray = com.badlogic.gdx.utils.Array
