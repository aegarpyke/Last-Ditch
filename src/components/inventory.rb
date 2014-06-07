class Inventory < Component

	attr_accessor :size, :items, :money

	def initialize(size)

		super()
		@size = size
		@money = 0.00
		@items = Array.new(size)

	end


	def add_item(item)

		for i in 0...@items.size

			if @items[i].nil?
				@items[i] = item
				return true
			end

		end

		false

	end


	def remove_item(item)

		index = @items.index(item)

		if index
			@items[index] = nil
			return true
		else
			return false
		end

	end


	def add_money(amount)

		@money += amount

	end


	def remove_money(amount)

		if @money > 0
			@money -= amount
			return true
		else
			return false
		end

	end

end
