module Sc2
  class Hasher
    def initialize
      set_enc_tbl
    end

    def hash_for hash_type, s
      hash_type = [:table_offset, :hash_a, :hash_b, :table].index hash_type
      seed1, seed2 = 0x7FED7FED, 0xEEEEEEEE
      s.upcase.each_byte do |c|
        value = @encryption_table[(hash_type << 8) + c]
        seed1 = (value ^ (seed1 + seed2)) & 0xFFFFFFFF
        seed2 = (c + seed1 + seed2 + (seed2 << 5) + 3) & 0xFFFFFFFF
      end
      seed1
    end

    def decrypt data, seed1
      seed2 = 0xEEEEEEEE
      data.unpack('V*').map do |value|
        seed2 = (seed2 + @encryption_table[0x400 + (seed1 & 0xFF)]) & 0xFFFFFFFF
        value = (value ^ (seed1 + seed2)) & 0xFFFFFFFF
        seed1 = (((~seed1 << 0x15) + 0x11111111) | (seed1 >> 0x0B)) & 0xFFFFFFFF
        seed2 = (value + seed2 + (seed2 << 5) + 3) & 0xFFFFFFFF
        value
      end.pack('V*')
    end

  private
    def set_enc_tbl
      seed = 0x00100001
      @encryption_table = {}
      (0..255).each do |i|
        index = i
        (0..4).each do |j|
          seed = (seed * 125 + 3) % 0x2AAAAB
          tmp1 = (seed & 0xFFFF) << 0x10
          seed = (seed * 125 + 3) % 0x2AAAAB
          tmp2 = (seed & 0xFFFF)
          @encryption_table[i + j * 0x100] = (tmp1 | tmp2)
        end
      end
    end
  end
end
