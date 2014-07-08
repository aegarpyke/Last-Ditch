class RenderSystem < System

	attr_accessor :nearby_entities

	def initialize(mgr, player, atlas)

		@mgr = mgr
		@player = player
		@update_timer = 0
		@nearby_entities = []

		entities = @mgr.entities_with(Render)
		entities.each do |entity|

			render = @mgr.comp(entity, Render)
			render.region = atlas.find_region(render.region_name)

			pos = @mgr.comp(entity, Position)
			player_pos = @mgr.comp(@player, Position)

			(pos.x - player_pos.x).between?(-20, 20) and
			(pos.y - player_pos.y).between?(-20, 20) and
			@nearby_entities << entity

		end

		entities = @mgr.entities_with(Animation)
		entities.each do |entity|

			first = true

			anim = @mgr.comp(entity, Animation)
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

			entities = @mgr.entities_with(Position)
			entities.each do |entity|

				pos = @mgr.comp(entity, Position)
				player_pos = @mgr.comp(@player, Position)

				(pos.x - player_pos.x).between?(-20, 20) and
				(pos.y - player_pos.y).between?(-20, 20) and
				@nearby_entities << entity

			end

		end

		entities = @mgr.entities_with(Velocity)
		entities.each do |entity|

			anim = @mgr.comp(entity, Animation)
			col = @mgr.comp(entity, Collision)

			anim.state_time += C::BOX_STEP
			vel_vec = col.body.linear_velocity

			if entity == @player

				info = @mgr.comp(@player, Info)

				if vel_vec.x.abs < 0.02 && vel_vec.y.abs < 0.02
					anim.cur = "#{info.gender}1/idle"
				elsif anim.cur != "#{info.gender}1/walk"
					anim.cur = "#{info.gender}1/walk"
				end
			
			end

		end

	end


	def render(batch)

		@nearby_entities.each do |entity|

			pos    = @mgr.comp(entity, Position)
			rot    = @mgr.comp(entity, Rotation)
			size   = @mgr.comp(entity, Size)
			render = @mgr.comp(entity, Render)

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

			pos = @mgr.comp(entity, Position)
			rot = @mgr.comp(entity, Rotation)
			size = @mgr.comp(entity, Size)
			anim = @mgr.comp(entity, Animation)

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

		anim = @mgr.comp(@player, Animation)
		pos = @mgr.comp(@player, Position)
		rot = @mgr.comp(@player, Rotation)

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