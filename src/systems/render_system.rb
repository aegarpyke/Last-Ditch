class RenderSystem < System

	attr_accessor :nearby_entities

	def initialize(mgr, player, atlas)

		@mgr = mgr
		@player = player
		@update_timer = 0
		@nearby_entities = []

		entities = @mgr.get_all_entities_with(Render)
		entities.each do |entity|

			render = @mgr.get_component(entity, Render)
			render.region = atlas.find_region(render.region_name)

			pos = @mgr.get_component(entity, Position)
			player_pos = @mgr.get_component(@player, Position)

			if (pos.x - player_pos.x).abs < 20 &&
				 (pos.y - player_pos.y).abs < 18

				@nearby_entities << entity

			end

		end

		entities = @mgr.get_all_entities_with(Animation)
		entities.each do |entity|

			first = true

			anim = @mgr.get_component(entity, Animation)
			anim.names_and_frames.each do |name, frames|

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
				anim.anims[name] = com.badlogic.gdx.graphics.g2d.Animation.new(
					anim.duration, frame_list)

				if first
					first = false
					anim.cur = name
				end

			end

		end

	end


	def update
		
		unless @update_timer > 100

			# Scale update_timer based on player walking/running
			@update_timer += 1

		else

			@update_timer = 0
			@nearby_entities = []

			entities = @mgr.get_all_entities_with(Position)
			entities.each do |entity|

				pos = @mgr.get_component(entity, Position)
				player_pos = @mgr.get_component(@player, Position)

				if (pos.x - player_pos.x).abs < 20 &&
					 (pos.y - player_pos.y).abs < 18

					@nearby_entities << entity

				end

			end

		end

		entities = @mgr.get_all_entities_with(Velocity)
		entities.each do |entity|

			anim = @mgr.get_component(entity, Animation)
			vel = @mgr.get_component(entity, Velocity)
			col = @mgr.get_component(entity, Collision)

			anim.state_time += C::BOX_STEP

			vel = col.body.linear_velocity

			if entity == @player
				
				if vel.x.abs < 0.02 && vel.y.abs < 0.02
					anim.cur = 'player_idle'
				elsif anim.cur != 'player_walk'
					anim.cur = 'player_walk'
				end
			
			end

		end

	end


	def render(batch)

		@nearby_entities.each do |entity|

			pos = @mgr.get_component(entity, Position)
			rot = @mgr.get_component(entity, Rotation)
			size = @mgr.get_component(entity, Size)
			render = @mgr.get_component(entity, Render)

			if render
			
				batch.draw(
					render.region,
					C::BTW * (pos.x - size.width/2),
					C::BTW * (pos.y - size.height/2),
					C::BTW * size.width/2, C::BTW * size.height/2,
					C::BTW * size.width, C::BTW * size.height,
					render.scale, render.scale,
					rot.angle)
			
			end

		end

		@nearby_entities.each do |entity|

			pos = @mgr.get_component(entity, Position)
			rot = @mgr.get_component(entity, Rotation)
			size = @mgr.get_component(entity, Size)
			anim = @mgr.get_component(entity, Animation)

			if anim

				batch.draw(
					anim.key_frame, 
					C::BTW * pos.x - anim.width/2,
					C::BTW * pos.y - anim.height/2,
					anim.width/2, anim.height/2,
					anim.width, anim.height, 
					anim.scale, anim.scale, 
					rot.angle)

			end

		end

		anim = @mgr.get_component(@player, Animation)
		pos = @mgr.get_component(@player, Position)
		rot = @mgr.get_component(@player, Rotation)

		batch.draw(
			anim.key_frame, 
			C::BTW * pos.x - anim.width/2,
			C::BTW * pos.y - anim.height/2,
			anim.width/2, anim.height/2,
			anim.width, anim.height, 
			anim.scale, anim.scale, 
			rot.angle)

	end

end