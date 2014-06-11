class RenderSystem < System

	attr_accessor :nearby_entities

	def initialize(mgr, player, atlas)

		@mgr = mgr
		@player = player
		@update_timer = 0
		@nearby_entities = []

		entities = @mgr.get_all_entities_with(Render)
		entities.each do |entity|

			render_comp = @mgr.get_component(entity, Render)
			render_comp.region = atlas.find_region(render_comp.region_name)

			pos_comp = @mgr.get_component(entity, Position)
			player_pos_comp = @mgr.get_component(@player, Position)

			if (pos_comp.x - player_pos_comp.x).abs < 20 &&
				 (pos_comp.y - player_pos_comp.y).abs < 18

				@nearby_entities << entity

			end

		end

		entities = @mgr.get_all_entities_with(Animation)
		entities.each do |entity|

			anim_comp = @mgr.get_component(entity, Animation)
			anim_comp.names_and_frames.each do |name, frames|

				frame_list = []

				frames.each do |frame|

					if frame.end_with?("-f")
					
						frame.slice!("-f")
						region = TextureRegion.new(atlas.find_region(frame))
						region.flip(false, true)
						frame_list << region
					
					else
					
						frame_list << atlas.find_region(frame)
					
					end

				end

				frame_list = frame_list.to_java(TextureRegion)
				anim_comp.anims[name] = com.badlogic.gdx.graphics.g2d.Animation.new(0.1, frame_list)

			end

		end

		anim_comp = @mgr.get_component(@player, Animation)
		anim_comp.cur = 'player_walk'

	end


	def update
		
		unless @update_timer > 20

			# Scale update_timer based on player walking/running
			@update_timer += 1
			
		else

			@update_timer = 0
			@nearby_entities = []

			entities = @mgr.get_all_entities_with(Position)
			entities.each do |entity|

				pos_comp = @mgr.get_component(entity, Position)
				player_pos_comp = @mgr.get_component(@player, Position)

				if (pos_comp.x - player_pos_comp.x).abs < 20 &&
					 (pos_comp.y - player_pos_comp.y).abs < 18

					@nearby_entities << entity

				end

			end

		end

		unless @mgr.paused
			
			anim_comp = @mgr.get_component(@player, Animation)
			vel_comp = @mgr.get_component(@player, Velocity)
			col_comp = @mgr.get_component(@player, Collision)
			
			anim_comp.cur = 'player_walk'
			anim_comp.state_time += C::BOX_STEP

			vel = col_comp.body.linear_velocity

			if vel.x.abs < 0.02 && vel.y.abs < 0.02
				anim_comp.cur = 'player_idle'
			elsif anim_comp.cur != 'player_walk'
				anim_comp.cur = 'player_walk'
			end

		end

	end


	def render(batch)

		batch.begin

			@nearby_entities.each do |entity|

				pos_comp = @mgr.get_component(entity, Position)
				rot_comp = @mgr.get_component(entity, Rotation)
				size_comp = @mgr.get_component(entity, Size)
				render_comp = @mgr.get_component(entity, Render)

				if render_comp
					batch.draw(
						render_comp.region,
						C::BTW * (pos_comp.x - size_comp.width/2),
						C::BTW * (pos_comp.y - size_comp.height/2),
						C::BTW * size_comp.width/2, C::BTW * size_comp.height/2,
						C::BTW * size_comp.width, C::BTW * size_comp.height,
						render_comp.scale, render_comp.scale,
						rot_comp.angle)
				end

			end

			anim_comp = @mgr.get_component(@player, Animation)
			pos_comp = @mgr.get_component(@player, Position)
			rot_comp = @mgr.get_component(@player, Rotation)

			batch.draw(
				anim_comp.key_frame, 
				C::BTW * pos_comp.x - anim_comp.width/2,
				C::BTW * pos_comp.y - anim_comp.height/2,
				anim_comp.width/2, anim_comp.height/2,
				anim_comp.width, anim_comp.height, 
				anim_comp.scale, anim_comp.scale, 
				rot_comp.angle)

		batch.end

	end

end