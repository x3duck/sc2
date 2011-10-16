module Sc2
  class BlockTableEntry < BinData::Record
    endian :little
    int32  :block_offset
    int32  :archived_size
    int32  :file_size
    uint32 :flags

    def file?
	    (flags & 0x80000000) != 0
    end

    def compressed?
	    (flags & 0x00000200) != 0
    end

    def encrypted?
	    (flags & 0x00010000) != 0
    end

    def single_unit?
	    (flags & 0x01000000) != 0
    end
  end
end
