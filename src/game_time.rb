class GameTime

	attr_accessor :duration, :rate, :minute, :hour, :day, :month, :year

	def initialize

		@rate = 1.0
		@duration = 0.0
		@hour, @minute = 23, 50
		@day, @month, @year = 30, 12, 3124

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


	def tick(delta)

		@minute += @rate * delta
		@duration += @rate * delta

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