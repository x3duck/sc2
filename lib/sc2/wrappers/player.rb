module Sc2
  class Player
    OUTCOMES = [:unknown, :win, :loss]
    ATTRIBUTES = { :player_race => { "RAND" => :random, "Terr" => 'terran', "Prot" => 'protoss', "Zerg" => 'zerg' } }
    def initialize params
      @params = params
      @params[:outcome] = OUTCOMES[@params[:outcome]]
      @params[:attrs].compact!
      @params[:attrs].each { |attr| attr[:value].reverse! }
    end

    def race
      @params[:attrs].each do |attr|
        return ATTRIBUTES[:player_race][attr[:value]] if attr[:attr_id] == 3001
      end
    end

    def id
      @params[:id]
    end

    def name
      @params[:name]
    end

    def win?
      @params[:outcome] == :win
    end

    def loss?
      @params[:outcome] == :loss
    end
  end
end
