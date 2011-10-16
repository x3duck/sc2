module Sc2
  class ArchiveHeader < BinData::Record
    endian :little
    string :archive_magic, :length => 4
    int32  :header_size
    int32  :archive_size
    int16  :format_version
    int8   :sector_size_shift
    int8
    int32  :hash_table_offset
    int32  :block_table_offset
    int32  :hash_table_entries
    int32  :block_table_entries
    int64  :extended_block_table_offset
    int16  :hash_table_offset_high
    int16  :block_table_offset_high
  end
end
