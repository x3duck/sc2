# Starcraft 2 replay parser
------------------------
The Starcraft 2 replay parser is a gem that wraps the process of retrieving in-game statistics of a 
Starcraft 2 replays. The project is still raw so please post issues or send them to second.pilot@gmail.com

##installation
	gem install sc2

##usage
	require 'sc2'
	replay = Sc2::Replay.new(File.new('example.SC2Replay', 'r'))

	# call other methods

##replay methods
	player = replay.winner

	player = replay.loser

	replay.players
	
	replay.map

##player methods
  player.race
  
  player.win?
  
  player.name
  
  player.loss?
