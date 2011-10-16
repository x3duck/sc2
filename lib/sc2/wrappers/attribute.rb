module Sc2
  class Attribute < BinData::Record
    endian :little
    string :header, :length => 4
    uint32 :id
    uint8  :player
    string :val, :length => 4
  end
end
