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