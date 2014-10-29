require 'rubygems'
require 'sinatra'

set :sessions, true


#pseudo code
# get '/' do
# 	if user?
# 		progress to the game
# 	else
# 		redirect to new player form
# 	end
# end

helpers do #any methods defined within the helpers block are avaiable for both main.rb aswell as the templates


	def calculate_total(cards)  #we need a method that accepts the array of cards and calculates a total
		arr = cards.map{|e| e[1] }	

		total = 0
		arr.each do |value| 
			if value == "A"
				total += 11
			elsif value.to_i == 0 #if card value has no integer value (equals 0), add 10
				total += 10 #in instances of Jack, Queen, or King
			else
				total += value.to_i #if card has an integer value
			end
	end
	#correct for Aces
	arr.select{|e| e == "A"}.count.times do
			total -= 10 if total > 21	
		end
	total
	end
	#calculate_total(session[:dealers_cards]) => 20
end

before do #set of instance variable before each action
	@show_hit_or_stay_buttons = true
end

get '/' do 
	if session[:player_name]# able to reconsitute semi-persistent state through a semi-persistent cookies. 
		#progress to the game
		redirect '/game'
	else
		redirect '/new_player'
	end
end

get '/new_player' do 
	erb :new_player
end

post '/new_player' do 
	session[:player_name] = params[:player_name]
	redirect '/game'
end

get '/game' do
	#set up initial game values
		#deck -> create a deck and put it in session-> that will have a key value of deck
		suits = ['H', 'D', 'C', 'S']
		values = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'K', 'Q', 'J', 'A']
		session[:deck] = suits.product(values).shuffle
		#deal cards
		session[:dealer_cards] = []
		session[:player_cards] = []
			#dealer cards
			session[:dealer_cards] << session[:deck].pop
			session[:dealer_cards] << session[:deck].pop

			#player cards
			session[:player_cards] << session[:deck].pop
			session[:player_cards] << session[:deck].pop
	erb :game
end

post '/game/player/hit' do 
	session[:player_cards] << session[:deck].pop
	#instance variables are the best to use in this case to communicate to the layout template 
	#because they go away as soon as another request comes in.
	#@error is a perfect case for thiserb :game
	if calculate_total(session[:player_cards]) > 21
			@error = "Sorry, it looks like you busted."
			@show_hit_or_stay_buttons = false
		end
		erb :game
	end

post '/game/player/stay' do 
	@success = "You have chosen to stay!"
	@show_hit_or_stay_buttons = false
	erb :game

end