class System

	def update
		raise RuntimeError('Systems must override update')
	end

end
