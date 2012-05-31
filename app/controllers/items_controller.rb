class ItemsController < ApplicationController

	def index 
		if (params["user_id"].to_s.blank?)
			redirect_to "https://www.facebook.com/dialog/oauth?client_id=389450951093631&redirect_uri=https://apps.facebook.com/nm_thisorthat/"
		else
		
			@body_id = "index"
			@items = Item.all
		
			num1 = 1 + rand(@items.count)
		
			begin
				num2 = 1 + rand(@items.count) 
			end while num2 == num1
		
			@item1 = Item.find(num1)
			@item2 = Item.find(num2)
		
		end
	end
	
	def list
		@body_id = "list"
		@items = Item.find(:all, :order => 'rank DESC', :limit => 12)
		@i = 1
		
		@items.each do |item|
			item.number = @i
			@i += 1
		end
		
	end
	
	def show
	end
	
	def showleft
		@body_id = "index"
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
		@body_id = "index"
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
