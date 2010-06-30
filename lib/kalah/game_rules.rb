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
      
      move_list.each do |m|
        return true if move == m
      end
      
      false
    end
    
    # Returns +1 if player +1 has won in the given game state, 
    # -1 if player -1 has won, and 0 if no one has won.
    # @param gs game state to be checked
    def is_win?(game_state)
      position = @referee.player(game_state.turn).position
      return +game_state.turn if game_state.game_board.kalah(position) > game_state.game_board.TOTAL_STONES/2
      return -game_state.turn if game_state.game_board.opponent_kalah(position) > game_state.game_board.TOTAL_STONES/2
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
    
    # A better evaluation function which gives more preference to moves
    # that wrap around back to my side or to the opponent's side
    #
    # TODO: This heuristic reeks of uselessness. Try it. Its no better than
    # the raw game_state.score
    def wrap_eval(game_state,move)
        # if the game is over, give a 1000 point bonus to the winning player
        if is_over?(game_state)
          score = game_state.score(move.position)
          if score > 0
            return 1000
          elsif score < 0
            return -1000
          else
            return 0
          end
        end
        
        score = game_state.score(move.position)
        end_pit = move.pit + game_state.game_board.pits(move.position)[move.pit-1]
        if end_pit > 12
          score += 2
        elsif end_pit > 6
          score += 1
        end
        
        score
      end
  end
end
