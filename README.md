# Starcraft 2 replay parser

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
