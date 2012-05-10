class ItemsController < ApplicationController

	def index 
		@items = Item.all
		
		num1 = 1 + rand(@items.count)
		
		begin
			num2 = 1 + rand(@items.count) 
		end while num2 == num1
		
		@item1 = Item.find(num1)
		@item2 = Item.find(num2)
	end
	
	def list
		@items = Item.find(:all, :order => 'rank DESC')
		i = 0
		previous = 0
		@items.each do |item|
			if item.rank == previous
				item.number = i
			else 
				item.number = i + 1
			end
			i = i + 1
			previous = item.rank
		end
	end
	
	def show
	end
	
	def showleft
		@item1 = Item.find(params[:id])
		
		@items = Item.all
		begin 
			num = 1 + rand(@items.count)
		end while num == @item1.id
		
		@item2 = Item.find(num)
		
		changeRanks(@item1, @item2)
		
		render "index"
	end
	
	def showright
		@item2 = Item.find(params[:id])
		
		@items = Item.all
		begin
			num = 1 + rand(@items.count)
		end while num == @item2.id
		
		@item1 = Item.find(num)
		
		changeRanks(@item2, @item1)
		
		render "index"
	end
	
	private 
	def changeRanks(winner, loser)
		@e_winner = 1/(1+10**((loser.rank - winner.rank)/400.0))
		@e_loser = 1/(1 + 10 ** ((winner.rank - loser.rank)/400.0))
		
		@winner_newrank = winner.rank + 10 * (1 - @e_winner)
		@loser_newrank = loser.rank + 10 * (0 - @e_loser)
		
		winner.update_attribute(:rank, @winner_newrank)
		loser.update_attribute(:rank, @loser_newrank)
	end
	


end
