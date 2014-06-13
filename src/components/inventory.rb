class Inventory < Component

	attr_accessor :size, :items, :money, :weight

	def initialize(size)

		super()
		@size = size
		@money = 3.11
		@weight = 0
		@items = Array.new(size)

	end


	def add_item(item_id)

		for i in 0...@items.size

			if @items[i].nil?

				@items[i] = item_id
				return true
			
			end

		end

		false

	end


	def remove_item(item_id)

		index = @items.index(item_id)

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
