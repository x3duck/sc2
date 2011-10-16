module Sc2
  class Parser
    def self.parse data
      self.parse_recur String.new data
    end

    def self.parse_recur data
      case data.slice!(0).bytes.next
        when 2
          data.slice! 0, vlf(data)
        when 4
          data.slice! 0, 2
          (0...vlf(data)).map {|i| parse_recur data }
        when 5
          Hash.[]((0...vlf(data)).map do |i| 
            [vlf(data), parse_recur(data)]
          end)
        when 6
          data.slice! 0
        when 7
          data.slice!(0, 4).unpack("V")[0]
        when 9
          vlf data
        else
          nil
      end
    end

    def self.vlf data
      ret, shift = 0, 0
      loop do
        char = data.slice!(0)
        return nil unless char
        byte = char.bytes.next
        ret += (byte & 0x7F) << (7 * shift)
        break if byte & 0x80 == 0
        shift += 1
      end
      (ret >> 1) * ((ret & 0x1) == 0 ? 1 : -1)
    end
  end
end
