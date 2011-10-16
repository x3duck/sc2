module Sc2
  class UserHeader < BinData::Record
    endian :little
    string :user_magic, :length => 4
    uint32 :user_data_max_length
    uint32 :archive_header_offset
    uint32 :user_data_length
    string :user_data, :length => :user_data_length
  end
end
