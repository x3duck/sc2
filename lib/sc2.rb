require 'rubygems'
require 'bindata'
require 'bzip2-ruby'
Dir['./wrappers/*.rb'].each { |f| require f }
Dir['./magick/*.rb'].each { |f| require f }

module Sc2
  class Replay
    def initialize rep_file
    @reader = Reader.new rep_file
      @replay = Hash[:details, Parser.parse(@reader.read_file('replay.details')), 
      :initData, InitData.read(@reader.read_file('replay.initData')),
      :userData, Parser.parse(@reader.user_hdr.user_data),
      :gameVersion, '']
      @replay[:gameVersion] = { :major => @replay[:userData][1][1], :minor => @replay[:userData][1][2], :patch => @replay[:userData[1][3]], :build => @replay[:userData][1][4] }
      @replay[:players] = p_players
    end

    def map
      @replay[:details][1]
    end

    def winner
      @replay[:players].each { |player| return player if player.win? }
    end
    
    def loser
      @replay[:players].each { |player| return player if !player.win? }
    end

    def players
      @replay[:players]
    end

  private
    def attributes
      return @attributes if defined? @attributes
      data = @reader.read_file "replay.attributes.events"
      data.slice! 0, (@replay[:gameVersion][:build] < 17326 ? 4 : 5)
      @attributes = []
      data.slice!(0, 4).unpack("V")[0].times { @attributes << Attribute.read(data.slice!(0, 13)) }
      @attributes
    end

    def p_players
      return @players if defined? @players
      player_id = 0
      @players = @replay[:details][0].map { |player| Player.new ({ :name => player[0], :outcome => player[8], :id => player_id += 1, :attrs =>  attributes.map { |attr| { :attr_id => attr[:id], :value => attr[:val] } if attr[:player] == player_id } }) }
    end
  end
end
