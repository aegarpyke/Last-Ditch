class TimeSystem < System

	attr_accessor :active, :game_delta, :duration, :rate, :minute, :hour, :day, :month, :year

	def initialize

		super()
		@game_delta = 0
		@rate = 1.0
		@active = true
		@duration = 0.0

		@hour, @minute = 0, 0
		@day, @month, @year = 1, 1, 3127

	end

	
	def time

		if @hour < 10
			if @minute < 10
				return "0%d:0%d" % [@hour, @minute]
			else
				return "0%d:%d" % [@hour, @minute]
			end
		else
			if @minute < 10
				return "%d:0%d" % [@hour, @minute]
			else
				return "%d:%d" % [@hour, @minute]
			end
		end

	end


	def date

		if @month < 10
			if @day < 10
				return "0%d.0%d.%d" % [@day, @month, @year]
			else
				return "%d.0%d.%d" % [@day, @month, @year]
			end
		else
			if @day < 10
				return "0%d.%d.%d" % [@day, @month, @year]
			else
				return "%d.%d.%d" % [@day, @month, @year]
			end
		end

	end


	def update

		if @active

			@game_delta = @rate * C::BOX_STEP
			@minute += @game_delta
			@duration += @game_delta
			@game_delta = @game_delta

			if @minute > 60
				@minute = 0
				@hour += 1

				if @hour > 23
					@hour = 0
					@day += 1
					
					if @day > 30
						@day = 1
						@month += 1

						if @month > 12
							@month = 1
							@year += 1
						
						end
					end
				end
			end
		end

	end


	def dispose

	end

end