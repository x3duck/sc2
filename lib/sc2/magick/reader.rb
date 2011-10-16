module Sc2
  class Reader
    attr_reader :user_hdr
    def initialize rep_file
      @rep_file = rep_file
      set_hdrs
      set_tbls
    end

    def read_file file
      hasher = Hasher.new
      hash_a = hasher.hash_for :hash_a, file
      hash_b = hasher.hash_for :hash_b, file
      hash_entry = @hash_tbl.find { |h| [h.hash_a, h.hash_b] == [hash_a, hash_b] }
      block_entry = @block_tbl[hash_entry.block_index]
      @rep_file.seek @user_hdr.archive_header_offset + block_entry.block_offset
      file_data = @rep_file.read block_entry.archived_size
      if block_entry.single_unit?
        file_data = Bzip2.uncompress file_data[1, file_data.length] if block_entry.compressed? && file_data.bytes.next == 16
        return file_data
      end
      sector_size = 512 << @archive_hdr.sector_size_shift
      sectors = block_entry.size / sector_size + 1
      sectors += 1 if block_entry.has_checksums
      positions = file_data[0, 4 * (sectors + 1)].unpack "V#{sectors + 1}"
      sectors = []
      positions.each_with_index do |pos, i|
        break if i + 1 == positions.length
        sector = file_data[pos, positions[i + 1] - pos]
        sector = Bzip2.uncompress sector if block_entry.compressed? && block_entry.size > block_entry.archived_size && sector.bytes.next == 16
        sectors << sector
      end
      sectors.join ''
    end

  private
    def set_hdrs
      @user_hdr = UserHeader.read @rep_file
      @rep_file.seek @user_hdr.archive_header_offset
      @archive_hdr = ArchiveHeader.read @rep_file
    end

    def set_tbls
      @hash_tbl = read_tbl 'hash'
      @block_tbl = read_tbl 'block'
    end

    def read_tbl type
      tbl_offset = @archive_hdr[type + '_table_offset']
      @rep_file.seek @user_hdr.archive_header_offset + tbl_offset
      tbl_entries = @archive_hdr[type + '_table_entries']
      hasher = Hasher.new
      key = hasher.hash_for :table, "(#{type} table)"
      data = @rep_file.read tbl_entries * 16
      data = hasher.decrypt data, key
      layout = type == 'hash' ? HashTableEntry : BlockTableEntry
      (0...tbl_entries).map { |i| layout.read(data[i * 16, 16]) }
    end
  end
end
