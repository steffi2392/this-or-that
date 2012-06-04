class ItemsController < ApplicationController
	

	def index 
	
			@info = get_info()

			@body_id = "index"
			@items = Item.all
		
			num1 = 1 + rand(@items.count)
		
			begin
				num2 = 1 + rand(@items.count) 
			end while num2 == num1
		
			@item1 = Item.find(num1)
			@item2 = Item.find(num2)
			
			@pageurl = "https://www.facebook.com/NicoleMiller/app_389450951093631"
			
			@item1_pin = "http://pinterest.com/pin/create/button/?url=" + @pageurl + "&media=" + image_url(@item1.image_front) + "&description=DESCRIPTION"
			
			@item2_pin = "http://pinterest.com/pin/create/button/?url=" + @pageurl + "&media=" + image_url(@item2.image_front) + "&description=DESCRIPTION"
		
		
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
	
	def require_added
		if (@oauth_token.to_s.blank?)
			render :text=>%|<script>window.top.location.href = "https://graph.facebook.com/oauth/authorize?client_id=389450951093631&redirect_uri=https://apps.facebook.com/nm_thisorthat/";</script>|
			return false
		end
		true
		
	end
	
	 def parse_data
	
	    # This is a typical set of parameters passed by Facebook
	    # Parameters: {"signed_request"=>"vsSe9NNeyqom0hAtGyb2L9scc3-aNbY5Xb25EW55LpE.eyJhbGdvcml0aG0iOiJITUFDLVNIQTI1NiIsImV4cGlyZXMiOjEzMDA3NzAwMDAsImlzc3VlZF9hdCI6MTMwMDc2NDg2Niwib2F1dGhfdG9rZW4iOiIxNzE2MDQwOTI4NjgwNTd8Mi4xQnBWNm5mU2VXRm5RT0lOdzltNWFRX18uMzYwMC4xMzAwNzcwMDAwLTE1MjAwMzkxfEFpNXctc2t4WlJyVUd1ZzZvOU95aDZBQmdSZyIsInVzZXIiOnsiY291bnRyeSI6InVzIiwibG9jYWxlIjoiZW5fVVMiLCJhZ2UiOnsibWluIjoyMX19LCJ1c2VyX2lkIjoiMTUyMDAzOTEifQ"}
	
	    # If we have the signed_request parameters, stash them away
	    session[:signed_request] = params[:signed_request] if params[:signed_request]
	
	    encoded_user_data = session[:signed_request]
	
	    # We only care about the data after the '.'
	    payload = encoded_user_data.split(".")[1]
	
	    # Facebook gives us a base64URL encoded string. Ruby only supports base64 out of the box, so we have to add padding to make it work
	    payload += '=' * (4 - payload.length.modulo(4))
	
	    decoded_json = Base64.decode64(payload)
	    @signed_data = JSON.parse(decoded_json)
	
	    # This is what your parsed JSON should look like
	    # @signed_data => {"expires"=>1300770000, "algorithm"=>"HMAC-SHA256", "user_id"=>"15200391", "oauth_token"=>"171604092868057|2.1BpV6nfSeWFnQOINw9m5aQ__.3600.1300770000-15200391|Ai5w-skxZRrUGug6o9Oyh6ABgRg", "user"=>{"country"=>"us", "locale"=>"en_US", "age"=>{"min"=>21}}, "issued_at"=>1300764866}
	
	    #The existance of an oauth token means the user has given permission to the app.
	    @oauth_token = @signed_data["oauth_token"]
	
	  end
	  
	  def get_info
	  	
	  	return request.env['omniauth.auth']
	  end


end
