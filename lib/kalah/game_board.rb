# methods in kalah_working, not here
# is_either_side_empty?
# to_pretty_s
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
        
    def sow(position,pit)      
      if position == :north
        sow_from_north(pit)
      elsif position == :south
        sow_from_south(pit)
      end
    end
    
    def sow_from_north(pit)
      _sow(pit, north_pits, south_pits, north_kalah)
    end
    
    def sow_from_south(pit)
      _sow(pit, south_pits, north_pits, south_kalah)
    end
        
    private
      def _sow(pit, my_pits, your_pits, my_kalah)
        if pit < 1 or pit > 6
          raise "Pit selection '#{pit}' outside acceptable range [1-6]"
        end
            
        stones_were_played_on_opponents_side = false

        stones = my_pits[pit-1]
        my_pits[pit-1] = 0

        while stones > 0
          # sow in my pits
          sow_in_pits(my_pits, pit, stones)
          check_go_again_move(stones, my_pits, your_pits, my_kalah, stones_were_played_on_opponents_side)
          stones = calculate_remaining_stones(stones, my_pits, pit)
          pit = 0 # set so looping move (wrap back to own pits) works

          # sow in my kalah
          sow_in_kalah(my_kalah) and stones -= 1 if stones > 0

          # sow in opponent pits
          stones_were_played_on_opponents_side = true if stones > 0
          sow_in_pits(your_pits, 0, stones)
          check_cascade_capture(stones, your_pits, my_kalah)
          stones = calculate_remaining_stones(stones, your_pits, 0)
        end
      end
      
      def calculate_remaining_stones(stones, pits, start_pit)
        stones - pits[start_pit,stones].length
      end
    
      def sow_in_pits(pits, start_pit, num_stones)
        pits[start_pit,num_stones] = pits[start_pit,num_stones].collect{ |x| x+1 }
      end
      

      def sow_in_kalah(kalah)
        # kalah is an array of length 1 to store an integer for increment
        # (pass by reference, but ints can't be modified -> new obj created)
        kalah.collect!{ |x| x+1 }
      end

      def check_go_again_move(stones, my_pits, your_pits, my_kalah, stones_were_played_on_opponents_side)
        last_stones = stones
        stones = stones - my_pits[0,stones].length
        # last stone fell on my side and in a non-empty pit and stones_were_played_on_opposites_side
        if stones == 0 and my_pits[last_stones-1] > 1 and stones_were_played_on_opponents_side
          _sow(last_stones, my_pits, your_pits, my_kalah) # Go Again Move
        end
      end
    
      def check_cascade_capture(stones, your_pits, my_kalah)
        last_stones = stones
        stones = stones - your_pits[0,stones].length
        # stones made it to opponents side and last stone fell on opponents side
        if last_stones > 0 and stones == 0
          # opponents pit has 2 or 3 stones (plus the one we added with our last drop)
          if your_pits[last_stones-1] == 2+1 or your_pits[last_stones-1] == 3+1
            cascade_capture(last_stones-1, your_pits, my_kalah)
          end
        end
      end
    
      def cascade_capture(pit, your_pits, my_kalah)
        stones = your_pits[pit]
        your_pits[pit] = 0
        my_kalah.collect!{ |x| x+stones }
      
        pit -= 1
        if your_pits[pit] == 2 or your_pits[pit] == 3
          cascade_capture(pit, your_pits, my_kalah)
        end
      end
  end
end