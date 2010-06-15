module Kalah
  class GameState
    
    attr_accessor :game_board, :turn
    
    def initialize(game_board=nil, turn=nil)
      @game_board = game_board ? GameBoard.new(game_board) : GameBoard.new
      @turn = turn || 1
      self.freeze
    end
    
    def initialize_copy(orig)
      @game_board = orig.game_board.clone
      @turn = orig.turn
      self.freeze
    end
    
    def apply_move(move)
      new_gs = self.clone

      if move.position == :north
        new_gs.sow_from_north(move.pit)
      elsif move.position == :south
        new_gs.sow_from_south(move.pit)
      end

      new_gs
    end
    
    def sow_from_north(pit)
      _sow(pit, game_board.north_pits, game_board.south_pits, game_board.north_kalah)
    end
    
    def sow_from_south(pit)
      _sow(pit, game_board.south_pits, game_board.north_pits, game_board.south_kalah)
    end
    
    def hash
      @game_board.hash*3 + @turn + 1
    end
    
    def to_s
      @game_board.to_s
    end
    
    def to_long_s
      @game_board.to_long_s
    end

    def ==(gs)
      gs.game_board == @game_board and gs.turn != @turn
    end
    
    def eql?(gs)
      self == gs
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
        stones = calculate_remaining_stones(stones, my_pits, 0)
        # last stone fell on my side and in a non-empty pit and stones_were_played_on_opposites_side
        if stones == 0 and my_pits[last_stones-1] > 1 and stones_were_played_on_opponents_side
          _sow(last_stones, my_pits, your_pits, my_kalah) # Go Again Move
        end
      end
    
      def check_cascade_capture(stones, your_pits, my_kalah)
        last_stones = stones
        stones = calculate_remaining_stones(stones, your_pits, 0)
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