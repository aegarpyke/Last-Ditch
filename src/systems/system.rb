class System

	def tick
		raise RuntimeError('Systems must override process_tick')
	end

end
