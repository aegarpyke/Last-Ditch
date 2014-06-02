class Inventory < Component

	attr_accessor :size, :items, :money

	def initialize(size)

		super()
		@size = size
		@money = 0.00
		@items = Array.new

	end


	def add_item(item)

		if @items.size < @size
			@items << item
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
