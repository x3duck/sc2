module Sc2
  class InitData < BinData::Record
    uint8 :num_players
    array :players, :initial_length => :num_players do
      uint8 :player_name_length
      string :player_name, :length => :player_name_length
      skip :length => 5
    end
    string :unknown_24, :length => 24
    uint8 :account_length
    string :account, :length => :account_length
    rest :rest
  end
end
