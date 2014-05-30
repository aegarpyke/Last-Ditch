class Inventory < Component

	attr_accessor :size, :items

	def initialize(size)

		super()
		@size = size
		@items = Array.new

	end


	def add_item(item)

		if(@items.size < @size)
			@items << item
			return true
		else
			return false
		end

	end

end
