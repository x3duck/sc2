module Sc2
  class HashTableEntry < BinData::Record
    endian :little
    uint32 :hash_a
    uint32 :hash_b
    int16  :language
    int8   :platform
    int8
    int32  :block_index
  end
end
