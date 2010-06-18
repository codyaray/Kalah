module Kalah
  class GameRules

    def referee=(referee)
      # Referee encapsulates and coordinates Players and GameRules, but the 
      # GameRules needs access to the player's position (through Referee) 
      # based upon the current turn. The legal moves vary depending on who's
      # turn is up next (ie, player can only sow from their side of the board).
      # The referee is given the GameRules object during instantiation, and
      # passes itself to the object through this method.
      @referee = referee unless @referee
    end
    
    def legal_moves(game_state)
      move_list = []

      # Player can only sow from their side of the board
      if game_state.turn == +1
        position = @referee.player_pos.position
      elsif game_state.turn == -1
        position = @referee.player_neg.position
      end
      
      # Player can only sow from non-empty pits      
      pits = game_state.game_board.pits(position)
      if pits.sum == 0 # no moves available
        move_list << Move.new(position,0)
      else
        (1..6).each do |i|
          move_list << Move.new(position,i) if pits[i-1] > 0
        end
      end
      
      move_list
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
    
    def is_tie?(game_state)
      game_state.game_board.north_kalah[0] == game_state.game_board.TOTAL_STONES/2 and
        game_state.game_board.south_kalah[0] == game_state.game_board.TOTAL_STONES/2
    end
    
    def is_empty_side?(game_state)
      game_state.game_board.north_pits.sum == 0 or
        game_state.game_board.south_pits.sum == 0
    end
    
    def is_over?(game_state)
      is_win?(game_state) != 0 or is_tie?(game_state)
    end
  end
end
