class RenderSystem < System

	def initialize(mgr, atlas)

		@mgr = mgr

		entities = @mgr.get_all_entities_with(Render)
		entities.each do |entity|

			render_comp = @mgr.get_component(entity, Render)
			render_comp.region = atlas.find_region(render_comp.region_name)

		end

		entities = @mgr.get_all_entities_with(Animation)
		entities.each do |entity|

			anim_comp = @mgr.get_component(entity, Animation)
			anim_comp.names_and_frames.each do |name, frames|

				frame_list = []

				frames.each do |frame|
					frame_list << atlas.find_region(frame)
				end

				frame_list = frame_list.to_java(TextureRegion)
				anim_comp.anims[name] = com.badlogic.gdx.graphics.g2d.Animation.new(0.1, frame_list)

			end

		end

	end


	def tick(delta, batch)

		batch.begin

		entities = @mgr.get_all_entities_with(Render)
		entities.each do |entity|

			pos_comp = @mgr.get_component(entity, Position)
			rot_comp = @mgr.get_component(entity, Rotation)
			render_comp = @mgr.get_component(entity, Render)

			batch.draw(
				render_comp.region,
				C::BTW * pos_comp.x - render_comp.width/2,
				C::BTW * pos_comp.y - render_comp.height/2,
				render_comp.width/2, render_comp.height/2,
				render_comp.width, render_comp.height,
				render_comp.scale, render_comp.scale,
				rot_comp.angle)

		end

		entities = @mgr.get_all_entities_with(Animation)
		entities.each do |entity|

			anim_comp = @mgr.get_component(entity, Animation)
			pos_comp = @mgr.get_component(entity, Position)
			rot_comp = @mgr.get_component(entity, Rotation)

			unless @mgr.paused
				
				vel_comp = @mgr.get_component(entity, Velocity)
				col_comp = @mgr.get_component(entity, Collision)
				
				anim_comp.cur = 'player_walk'
				anim_comp.state_time += delta

				vel = col_comp.body.linear_velocity

				if @mgr.paused || vel.x.abs < 0.01 && vel.y.abs < 0.01
					anim_comp.cur = 'player_idle'
				elsif anim_comp.cur != 'player_walk'
					anim_comp.cur = 'player_walk'
				end

				pos_comp.x = col_comp.body.position.x
				pos_comp.y = col_comp.body.position.y
			
			end

			batch.draw(
				anim_comp.key_frame, 
				C::BTW * pos_comp.x - anim_comp.width/2,
				C::BTW * pos_comp.y - anim_comp.height/2,
				anim_comp.width/2, anim_comp.height/2,
				anim_comp.width, anim_comp.height, 
				anim_comp.scale, anim_comp.scale, 
				rot_comp.angle)

		end

		batch.end

	end

end