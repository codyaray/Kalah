module Kalah
  class GameBoard
    
    attr_accessor :north_pits, :south_pits   # arrays of integers
    attr_accessor :north_kalah, :south_kalah # unit length integer arrays
    attr_reader   :TOTAL_STONES              # integer
    
    DEFAULT_S = "6 6 6 6 6 6  6 6 6 6 6 6  0 0"
        
    def initialize(*board)
      if board.length == 0
        from_s(DEFAULT_S)
      elsif board.length == 1
        from_s(board[0])
      elsif board.length == 4
        set(board[0], board[1], board[2], board[3])
      end
    end
    
    def initialize_copy(orig)
      set(orig.north_pits.clone,orig.south_pits.clone,orig.north_kalah.clone,orig.south_kalah.clone)
    end
    
    def kalah(position)
      if position == :north
        return north_kalah
      elsif position == :south
        return south_kalah
      end
    end
    
    def pits(position)
      if position == :north
        return north_pits
      elsif position == :south
        return south_pits
      end
    end
    
    def set(north_pits, south_pits, north_kalah, south_kalah)
      @north_pits  = north_pits
      @south_pits  = south_pits
      @north_kalah = north_kalah
      @south_kalah = south_kalah

      @TOTAL_STONES = north_pits.sum + south_pits.sum + north_kalah[0] + south_kalah[0]
    end
    
    def from_s(board)
      board = board.split.collect{ |x| x.to_i }
      set(board[0,6], board[6,6], board[12,1], board[13,1])
    end
    
    def to_s
      north_pits.join(" ") + "  " + south_pits.join(" ") + "  " + north_kalah.to_s + " " + south_kalah.to_s
    end
    
    def to_long_s
      sprintf("   %2s\n%2s                   %2s\n   %2s",
        north_pits.reverse.sjoin("%2s"," "), north_kalah.to_s,
        south_kalah.to_s, south_pits.sjoin("%2s"," "))
    end
    
    def hash
      h = 0
      (0..north_pits.length-1).each do |n|
        h = h*3 + north_pits[n] + 1
        (0..south_pits.length-1).each do |s|
          h = h*3 + south_pits[s] + 1
        end
      end
      h = h*3 + north_kalah[0] + 1
      h = h*3 + south_kalah[0] + 1
    end
    
    def ==(gb)
      (0..north_pits.length-1).each do |n|
        return false if gb.north_pits[n] != north_pits[n]
        (0..south_pits.length-1).each do |s|
          return false if gb.south_pits[s] != south_pits[s]
        end
      end
      return false if gb.north_kalah[0] != north_kalah[0]
      return false if gb.south_kalah[0] != south_kalah[0]
      true
    end
    
    def eql?(gb)
      self == gb
    end
  end
end