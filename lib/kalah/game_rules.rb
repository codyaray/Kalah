module Kalah
  class GameRules    
    def legal_moves(game_state)
      
    end
    
    # Tests whether the given game state and the move from it are legal
    # according to the game rules.
    # @param gs game state to be checked
    # @param move move to be checked
    def is_legal?(game_state, move)
      move_list = legal_moves(game_state)
      
      (0..move_list.length-1).each do |i|
        return true if move == move_list[i]
      end

      false
    end
    
    # Returns +1 if player +1 has won in the given game state, 
    # -1 if player -1 has won, and 0 if no one has won.
    # @param gs game state to be checked
    def is_win?(game_state)
      return +1 if game_state.game_board.north_kalah[0] > game_state.game_board.TOTAL_STONES/2
      return -1 if game_state.game_board.south_kalah[0] > game_state.game_board.TOTAL_STONES/2
      0
    end
  end
end
